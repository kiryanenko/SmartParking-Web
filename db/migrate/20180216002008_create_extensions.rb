class CreateExtensions < ActiveRecord::Migration[5.2]
  def change
    enable_extension "postgis"
    enable_extension "btree_gin"
    enable_extension "btree_gist"
  end
end