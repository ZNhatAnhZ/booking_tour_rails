User.create!(name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  role: 0,
  activated: true,
  activated_at: Time.zone.now
)

50.times do |n|
  name = "khoa-#{n+1}"
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
  end

puts "user"

10.times do |n|
    name = "Example category #{n+1}"
    Category.create!(name: name)
  end

puts "category"
40.times do |n|
    category_id = (n % 9) + 1
    name = "Example tour #{n+1}"
    description = "lorem " * 5
    price = n * 20 + 1
    avg_rating = n % 5
    date1 = Time.now - 60 * 60 * 24 * (n % 10)
    date2 = Time.now
    start_date = Time.at((date2.to_f - date1.to_f)*rand + date1.to_f)
    end_date = start_date + 60 * 60 * 24 * n
    image = File.open("app/assets/images/tour-4.jpg")
    stock = (n % 10) * 3 + 5
    tour = Tour.create(name: name,
                 description: description,
                 price: price,
                 avg_rating: avg_rating,
                 start_date: start_date,
                 end_date: end_date,
                 stock: stock
  )
    tour.image.attach(io: image, filename: "tour-4.jpg")
    tour.category_id = category_id
    tour.save!
  end

  puts "tour"
100.times do |n|
    content = "Example review #{n+1}"
    rating = (n % 5) + 1
    user_id = (n % 20) + 1
    tour_id = (n % 20) + 1
    review = Review.create(content: content, rating: rating)
    review.user_id = user_id
    review.tour_id = tour_id
    review.save!
  end
  puts "review"

70.times do |n|
  user_id = n + 1
  tour_id = (n % 39) + 1
  tour = Tour.find_by(id: tour_id)
  return unless Date.today.to_s < tour.start_date
  quantity = (n % 10) + 1
  return if quantity > tour.stock
  total_price = quantity * Tour.find_by(id: tour_id).price
  tour_request = TourRequest.create(user_id: user_id, tour_id: tour_id, quantity: quantity, total_price: total_price)
  tour_request.save!
end

puts "tour_request"
