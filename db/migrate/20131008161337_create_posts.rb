class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.column(:title, :string)
      t.column(:description, :text)
      t.column(:date, :datetime)
      t.column(:image, :string)
      t.column(:thumbnail, :string)
      t.timestamps
    end
  end
  
end
