# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


account_owner = User.create(email: "account_owner@email.com", password: "12345678", role: :account_owner)
team_member1 = User.create(email: "team_member1@email.com", password: "12345678",account_owner: account_owner, role: :team_member)
team_member2 = User.create(email: "team_member2@email.com", password: "12345678", account_owner: account_owner, role: :team_member)

