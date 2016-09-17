class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.datetime :created_at
      t.datetime :updated_at
      t.integer  :job_id

      t.timestamps null: false
    end
  end
end
