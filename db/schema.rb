# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20220922095235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "options", force: :cascade do |t|
    t.string "opt_name"
    t.bigint "question_id"
    t.boolean "is_answer", default: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "quest_submissions", force: :cascade do |t|
    t.string "option"
    t.bigint "submission_id"
    t.integer "question_id"
    t.index ["submission_id"], name: "index_quest_submissions_on_submission_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "questions"
    t.bigint "quiz_id"
    t.integer "score"
    t.index ["quiz_id"], name: "index_questions_on_quiz_id"
  end

  create_table "questions_quizzes", force: :cascade do |t|
    t.bigint "quiz_id"
    t.bigint "question_id"
    t.index ["question_id"], name: "index_questions_quizzes_on_question_id"
    t.index ["quiz_id"], name: "index_questions_quizzes_on_quiz_id"
  end

  create_table "quiz_categories", force: :cascade do |t|
    t.integer "quiz_id"
    t.integer "category_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quiz_id"
    t.bigint "user_id"
    t.integer "score"
    t.index ["quiz_id"], name: "index_submissions_on_quiz_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "admin", default: false
    t.boolean "active_session_exists"
    t.string "otp_secret_key"
    t.string "phone"
  end

  add_foreign_key "options", "questions"
  add_foreign_key "quest_submissions", "submissions"
  add_foreign_key "questions", "quizzes"
  add_foreign_key "questions_quizzes", "questions"
  add_foreign_key "questions_quizzes", "quizzes"
  add_foreign_key "submissions", "quizzes"
  add_foreign_key "submissions", "users"
end
