import consumer from "./consumer"

const ice = {
  iceServers: [{ urls: ["stun:stun.l.google.com:19302"] }]
};

let pc = new RTCPeerConnection(ice);
let localVideo = null;
let remoteVideo = null;
let localStream = null;
let remoteStream = null;
let url = null;
let id = null;
let tempCandidateArray = [];

let constraints = {
  video: {
    width: { min: 640,ideal: 1920,max: 1920 },
    height: { min: 480,ideal: 1080,max: 1080 }
  },
  audio: true
}

$(document).on('turbolinks:load',async function () {
  localVideo = document.getElementById("local-video");
  remoteVideo = document.getElementById("remote-video");

  if (localVideo && remoteVideo) {
    await setUp();
    Init();
  }
});

async function setUp() {
  localStream = await navigator.mediaDevices.getUserMedia(constraints)
  remoteStream = new MediaStream();

  localStream.getTracks().forEach(track => {
    pc.addTrack(track,localStream)
  });

  pc.ontrack = event => {
    event.streams[0].getTracks().forEach(track => {
      remoteStream.addTrack(track);
    })
  }

  localVideo.srcObject = localStream;
  remoteVideo.srcObject = remoteStream;

  url = window.location.pathname;
  id = url.substring(url.lastIndexOf('/') + 1);

  $("#toggle-video-on").on('click',toggleCamera);
  $("#toggle-video-off").on('click',toggleCamera);
  $("#toggle-audio-on").on('click',toggleAudio);
  $("#toggle-audio-off").on('click',toggleAudio);
}

function Init() {
  const authorizationChannel = consumer.subscriptions.create({ channel: "AuthorizationChannel",room: id },{
    connected: async () => {
      console.log("connect to authorization");
      await sendOffer(authorizationChannel);
    },

    received: async (data) => {
      if (getCookieValue("user_id") !== data.user_id) {
        console.log(data);
        if (!pc.currentRemoteDescription) {
          switch (data.type) {
            case "answer":
              await receiveAnswer(data);
              console.log("receive");
              break;
            case "offer":
              await sendAnswer(authorizationChannel,data);
              console.log("send");
              break;
          }
        }

        if (data?.candidate) {
          console.log("add candidate for both sides");
          if (!pc.currentRemoteDescription) {
            //ice candidate being pushed to queue if send before sdp
            tempCandidateArray.push(data.candidate);
          } else {
            pc.addIceCandidate(new RTCIceCandidate(data.candidate))
            while (tempCandidateArray.length > 0) {
              pc.addIceCandidate(new RTCIceCandidate(tempCandidateArray.pop()));
            }
          }
        }
      }
    },
  });

  $("#leave-button").on("click",() => {
    authorizationChannel.unsubscribe();
    console.log("leaving room");
  });
};

async function sendOffer(authorizationChannel) {
  //add event send candidates after send offer
  pc.onicecandidate = async (event) => {
    if (event.candidate) {
      authorizationChannel.send({ user_id: getCookieValue("user_id"),candidate: event.candidate.toJSON() })
    }
  }

  $("#join-button").off().click(async function () {
    $(this).toggle();
    $(".leave-button-container ").toggle();
    $("#leave-button").toggle();
    localVideo.classList.add("smallFrame");
    remoteVideo.style.display = "block";

    if (!pc.currentRemoteDescription) {
      //create offer and set that to local description
      const offerDescription = await pc.createOffer();
      await pc.setLocalDescription(offerDescription);
      const offer = {
        user_id: getCookieValue("user_id"),
        sdp: offerDescription.sdp,
        type: offerDescription.type
      }

      //send offer
      authorizationChannel.send(offer)
      console.log("send offer");
    }
  });
}

async function receiveAnswer(data) {
  //store remote video
  const answerDescription = new RTCSessionDescription(data);
  await pc.setRemoteDescription(answerDescription);
}

async function sendAnswer(authorizationChannel,data) {
  //add event send candidates after send answer
  pc.onicecandidate = (event) => {
    event.candidate && authorizationChannel.send({ user_id: getCookieValue("user_id"),candidate: event.candidate.toJSON() })
  }

  //set offer to remote description
  const offerDescription = new RTCSessionDescription(data);
  await pc.setRemoteDescription(offerDescription);

  $("#join-button").off().click(async function () {
    $(this).toggle();
    $(".leave-button-container ").toggle();
    $("#leave-button").toggle();
    localVideo.classList.add("smallFrame");
    remoteVideo.style.display = "block";

    if (!pc.currentRemoteDescription) {
      //create answer for that offer and set answer to local description
      const answerDescription = await pc.createAnswer();
      await pc.setLocalDescription(answerDescription);
      const answer = {
        user_id: getCookieValue("user_id"),
        sdp: answerDescription.sdp,
        type: answerDescription.type
      }

      //send answer
      authorizationChannel.send(answer)
      console.log("send answer");
    }
  })
}

global.getPC = () => {
  console.log(pc);
}

async function toggleCamera() {
  let videoTrack = localStream.getTracks().find(track => track.kind === "video")

  if (videoTrack.enabled) {
    videoTrack.enabled = false
  } else {
    videoTrack.enabled = true
  }

  $("#toggle-video-on").toggle();
  $("#toggle-video-off").toggle();
}

async function toggleAudio() {
  let audioTrack = localStream.getTracks().find(track => track.kind === "audio")

  if (audioTrack.enabled) {
    audioTrack.enabled = false
  } else {
    audioTrack.enabled = true
  }

  $("#toggle-audio-on").toggle();
  $("#toggle-audio-off").toggle();
}
