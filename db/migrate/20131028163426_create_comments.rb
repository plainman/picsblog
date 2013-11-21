class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.column(:name, :string)
      t.column(:text, :text)
      t.column(:email, :string)
      t.column(:url, :string)
      t.column(:created_at, :datetime)
      t.column(:post_id, :integer)
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end