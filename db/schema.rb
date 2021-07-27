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

ActiveRecord::Schema.define(version: 2021_07_27_083231) do

  create_table "course_subject_tasks", charset: "utf8", force: :cascade do |t|
    t.bigint "course_subject_id", null: false
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_subject_id", "created_at"], name: "index_course_subject_tasks_on_course_subject_id_and_created_at"
    t.index ["course_subject_id"], name: "index_course_subject_tasks_on_course_subject_id"
  end

  create_table "course_subjects", charset: "utf8", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "subject_id", null: false
    t.time "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id", "subject_id"], name: "index_course_subjects_on_course_id_and_subject_id", unique: true
    t.index ["course_id"], name: "index_course_subjects_on_course_id"
    t.index ["subject_id"], name: "index_course_subjects_on_subject_id"
  end

  create_table "courses", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "start_time"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_courses_on_name", unique: true
  end

  create_table "subjects", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.time "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
  end

  create_table "tasks", charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "subject_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["subject_id", "created_at"], name: "index_tasks_on_subject_id_and_created_at"
    t.index ["subject_id"], name: "index_tasks_on_subject_id"
  end

  create_table "user_course_subjects", charset: "utf8", force: :cascade do |t|
    t.bigint "user_course_id", null: false
    t.bigint "course_subject_id", null: false
    t.date "start_time"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_subject_id"], name: "index_user_course_subjects_on_course_subject_id"
    t.index ["user_course_id"], name: "index_user_course_subjects_on_user_course_id"
  end

  create_table "user_courses", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_user_courses_on_course_id"
    t.index ["user_id", "course_id"], name: "index_user_courses_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_user_courses_on_user_id"
  end

  create_table "user_reports", charset: "utf8", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "course_id", null: false
    t.text "content"
    t.datetime "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_id"], name: "index_user_reports_on_course_id"
    t.index ["user_id", "course_id", "created_at"], name: "index_user_reports_on_user_id_and_course_id_and_created_at"
    t.index ["user_id"], name: "index_user_reports_on_user_id"
  end

  create_table "user_tasks", charset: "utf8", force: :cascade do |t|
    t.bigint "user_course_subject_id", null: false
    t.bigint "course_subject_task_id", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["course_subject_task_id"], name: "index_user_tasks_on_course_subject_task_id"
    t.index ["user_course_subject_id"], name: "index_user_tasks_on_user_course_subject_id"
  end

  create_table "users", charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "full_name"
    t.integer "role_id", default: 2, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "course_subject_tasks", "course_subjects"
  add_foreign_key "course_subjects", "courses"
  add_foreign_key "course_subjects", "subjects"
  add_foreign_key "tasks", "subjects"
  add_foreign_key "user_course_subjects", "course_subjects"
  add_foreign_key "user_course_subjects", "user_courses"
  add_foreign_key "user_courses", "courses"
  add_foreign_key "user_courses", "users"
  add_foreign_key "user_reports", "courses"
  add_foreign_key "user_reports", "users"
  add_foreign_key "user_tasks", "course_subject_tasks"
  add_foreign_key "user_tasks", "user_course_subjects"
end
