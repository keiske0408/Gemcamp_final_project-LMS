# db/seeds/items_seeds.rb
require 'open-uri'

Item.destroy_all

10.times do
  categories = Category.all.sample(3) # Select 3 random categories
  item = Item.create!(
    name: Faker::Commerce.product_name,
    quantity: Faker::Number.between(from: 10, to: 100),
    minimum_tickets: Faker::Number.between(from: 1, to: 10),
    batch_count: Faker::Number.between(from: 1, to: 20),
    online_at: Faker::Time.between(from: Time.now - 30.days, to: Time.now),
    offline_at: Faker::Time.between(from: Time.now, to: Time.now + 30.days),
    image: Faker::Avatar.image(size: "300x300"), # Generate valid image URL
    status: Faker::Number.between(from: 0, to: 1) # Assuming 0 is active, 1 is inactive
  )
  item.categories << categories # Assign categories to the item
  puts "Item created: #{item.name} with categories #{categories.map(&:name).join(', ')}"
end

