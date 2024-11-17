# db/seeds/categories_seeds.rb

10.times do
  categories = Category.create!(
    name: Faker::Commerce.department(max: 1, fixed_amount: true)
  )
  puts "Category Created: #{categories.name}"
end
