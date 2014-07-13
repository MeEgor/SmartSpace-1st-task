class AddIndexOnGeocoorditates < ActiveRecord::Migration
  def change
    add_index :places, [:lat, :lon]
  end
end
