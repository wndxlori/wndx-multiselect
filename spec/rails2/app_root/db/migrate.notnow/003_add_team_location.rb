class AddTeamLocation < ActiveRecord::Migration
  def self.up
    add_column :teams, :latitude, :float
    add_column :teams, :longitude, :float
    Team.reset_column_information
    # Pre-populate with geocoded locations
    say_with_time "Adding geocoded team locations..." do
      Team.find(:all).each do |team|
        results = Geocoding::get(team.hometown)
        if results.status == Geocoding::GEO_SUCCESS
          team.latitude, team.longitude = results[0].latlon
          team.save!
        end
      end
    end
  end

  def self.down
    remove_column :teams, :latitude
    remove_column :teams, :longitude
  end
end
