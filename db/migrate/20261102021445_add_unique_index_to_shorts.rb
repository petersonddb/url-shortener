class AddUniqueIndexToShorts < ActiveRecord::Migration[8.0]
  def change
    add_index(:shorts, :token, unique: true)
  end
end
