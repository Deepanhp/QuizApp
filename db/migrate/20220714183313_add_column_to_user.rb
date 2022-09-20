class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :active_session_exists, :boolean
  end
end
