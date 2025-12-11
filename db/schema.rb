# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_08_15_090508) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batch_groups", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.string "batch_id"
    t.integer "generation_type"
    t.bigint "integration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "batch_status"
    t.jsonb "batch_request_counts"
    t.index ["integration_id"], name: "index_batch_groups_on_integration_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "generations", force: :cascade do |t|
    t.bigint "integration_id", null: false
    t.integer "status"
    t.integer "generation_type"
    t.json "old_content"
    t.json "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "errors_message"
    t.bigint "project_id"
    t.string "batch_id"
    t.boolean "published", default: false
    t.bigint "batch_group_id"
    t.index ["batch_group_id"], name: "index_generations_on_batch_group_id"
    t.index ["integration_id"], name: "index_generations_on_integration_id"
    t.index ["project_id"], name: "index_generations_on_project_id"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "integration_type"
    t.string "token"
    t.string "refresh_token"
    t.string "domain"
    t.string "domain_id"
    t.bigint "client_id"
    t.boolean "is_installed", default: true
    t.integer "merchant_id"
    t.string "google_access_token"
    t.string "google_refresh_token"
    t.datetime "google_expires_at"
    t.string "google_search_console_site"
    t.index ["client_id"], name: "index_integrations_on_client_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name"
    t.integer "monthly_searches"
    t.string "competition"
    t.jsonb "monthly_search_volumes"
    t.bigint "integration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["integration_id", "name"], name: "index_keywords_on_integration_id_and_name", unique: true
    t.index ["integration_id"], name: "index_keywords_on_integration_id"
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "amount"
    t.string "reference_number"
    t.bigint "subscription_discount_id"
    t.bigint "subscription_plan_id"
    t.bigint "subscription_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_discount_id"], name: "index_payments_on_subscription_discount_id"
    t.index ["subscription_id"], name: "index_payments_on_subscription_id"
    t.index ["subscription_plan_id"], name: "index_payments_on_subscription_plan_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "statistics", force: :cascade do |t|
    t.integer "product_title", default: 0
    t.integer "product_seo", default: 0
    t.integer "product_description", default: 0
    t.integer "collection_description", default: 0
    t.integer "collection_seo", default: 0
    t.integer "article_content", default: 0
    t.integer "article_excerpt", default: 0
    t.integer "article_seo", default: 0
    t.integer "images", default: 0
    t.integer "image_alt_text", default: 0
    t.decimal "total_words", precision: 10, scale: 2, default: "0.0"
    t.bigint "integration_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "article_title", default: 0
    t.integer "article_topics", default: 0
    t.index ["integration_id"], name: "index_statistics_on_integration_id"
  end

  create_table "subscription_discounts", force: :cascade do |t|
    t.string "code", null: false
    t.decimal "percentage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_plans", force: :cascade do |t|
    t.decimal "amount", null: false
    t.string "name", null: false
    t.integer "subscription_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "info", default: [], array: true
    t.decimal "total_generations_per_month"
    t.json "benefits"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.decimal "remaining_generations", null: false
    t.integer "status", null: false
    t.string "stripe_id"
    t.date "end_date"
    t.integer "remaining_images"
    t.date "renew_date"
    t.bigint "user_id"
    t.bigint "subscription_discount_id"
    t.bigint "subscription_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_discount_id"], name: "index_subscriptions_on_subscription_discount_id"
    t.index ["subscription_plan_id"], name: "index_subscriptions_on_subscription_plan_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "tag_projects", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_tag_projects_on_project_id"
    t.index ["tag_id"], name: "index_tag_projects_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "user_projects", id: false, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_user_projects_on_project_id"
    t.index ["user_id"], name: "index_user_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "AccountOwner"
    t.bigint "user_id"
    t.string "name"
    t.string "provider", default: "web"
    t.string "uid"
    t.string "stripe_customer_id"
    t.boolean "free_trial_used", default: false
    t.boolean "test_user", default: true
    t.boolean "is_store", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id"
  end

  add_foreign_key "batch_groups", "integrations"
  add_foreign_key "clients", "users"
  add_foreign_key "clients", "users", column: "users_id"
  add_foreign_key "generations", "batch_groups"
  add_foreign_key "generations", "integrations"
  add_foreign_key "generations", "projects"
  add_foreign_key "integrations", "clients"
  add_foreign_key "projects", "clients"
  add_foreign_key "statistics", "integrations"
  add_foreign_key "tags", "users"
  add_foreign_key "user_projects", "projects", on_delete: :cascade
  add_foreign_key "user_projects", "users", on_delete: :cascade
  add_foreign_key "users", "users"
end
