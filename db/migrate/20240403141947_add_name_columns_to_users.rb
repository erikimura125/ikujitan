class AddNameColumnsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nick_name, :string
    add_column :users, :family_name, :string
    add_column :users, :first_name, :string
    add_column :users, :family_name_kana, :string
    add_column :users, :first_name_kana, :string
  end
end
