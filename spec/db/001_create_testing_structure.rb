class CreateTestingStructure < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :name
      t.float :estimated_time
      t.float :spent_time
    end
  end
end
