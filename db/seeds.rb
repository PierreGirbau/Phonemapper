# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Cleaning database...'
Product.destroy_all

puts 'Creating brands...'
apple = Brand.new('Apple')
samsung = Brand.new('Samsung')

puts 'Creating products...'

IphoneModels = %w(3G 3GS 4 4S 5 5c 6s 6 '6 Plus' 6s '6s Plus' SE 7 '7 Plus' 8 '8 Plus' X)

products_attributes = [
  {
    brand: apple,
    model: 'Iphone',
    version: '6s',
    capacity:
    color:
    price:
    picture:
  },
  {
    brand: 'Apple',
    model: 'Iphone',
    version: '6s',
    capacity:
    color:
    price:
    picture:
  },
  {
    brand: 'Apple',
    model: 'Iphone',
    version: '6s',
    capacity:
    color:
    price:
    picture:
  },
  {
    brand: 'Apple',
    model: 'Iphone',
    version: '6s',
    capacity:
    color:
    price:
    picture:
  },


]

Product.create!(restaurants_attributes)
puts 'Finished!'
