# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.create(
  email: 'dago@bet.com.co',
  password: '123456',
  password_confirmation: '123456',
  name: 'dago',
  wallet_id: 1
)

user.save


user = User.create(
  email: 'jhon@bet.com.co',
  password: '123456',
  password_confirmation: '123456',
  name: 'jhon',
  wallet_id: 2
)

user.save


user = User.create(
  email: 'cristian@bet.com.co',
  password: '123456',
  password_confirmation: '123456',
  name: 'cristian',
  wallet_id: 3
)

user.save

user = User.create(
  email: 'camilo@bet.com.co',
  password: '123456',
  password_confirmation: '123456',
  name: 'camilo',
  wallet_id: 4
)

user.save
