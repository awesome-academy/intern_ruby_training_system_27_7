class CreateUserReports < ActiveRecord::Migration[6.1]
  def change
    create_table :user_reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.text :content
      t.datetime :date

      t.timestamps
    end

    add_index :user_reports, [:user_id, :course_id, :created_at]
  end
end
