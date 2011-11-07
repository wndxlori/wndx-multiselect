#require 'hpricot'
#require 'open-uri'

class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.string :sur_name
      t.string :given_name
      t.string :position
      t.string :team_abbreviation
      t.date :birth_date
      t.string :place_of_birth
      t.timestamps
    end
  end

  def self.down
    drop_table :players
  end
end
