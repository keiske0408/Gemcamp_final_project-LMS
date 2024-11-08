User.destroy_all

def generate_philippine_phone
  # Generates numbers starting with '09' or '+639'
  prefixes = ['09', '+639']
  prefix = prefixes.sample
  number = "#{prefix}#{rand(100000000..999999999)}"
  # Example output: '09123456789' or '+639123456789'
  number
end

5.times do
  begin
    user = User.create!(
      email: Faker::Internet.unique.email,
      password: 'password123', # Devise requires valid password
      password_confirmation: 'password123',
      username: Faker::Internet.username,
      phone_number: generate_philippine_phone, # Valid PH number
      coins: rand(0..100),
      total_deposit: Faker::Commerce.price(range: 0..10_000),
      children_members: rand(0..5),
      genre: User.genres.keys.sample,
      created_at: Time.zone.now,
      updated_at: Time.zone.now
    )

    puts "Created user: #{user.email}"
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to create user: #{e.message}"
  end
end

puts "Seeding completed!"
