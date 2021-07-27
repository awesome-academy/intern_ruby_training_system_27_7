class CreateSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :subjects do |t|
      t.string :name
      t.text :description
      t.time :duration

      t.timestamps
    end

    add_index :subjects, :name, unique: true
  end
end
