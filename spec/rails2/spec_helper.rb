$: << File.join(File.dirname(__FILE__), "/../lib" )

# Load the Rails environment and testing framework
require "#{File.dirname(__FILE__)}/app_root/config/environment"
require "#{File.dirname(__FILE__)}/../../init"
require 'spec/rails'

# Undo changes to RAILS_ENV
silence_warnings {RAILS_ENV = ENV['RAILS_ENV']}

# Run the migrations
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")

def save_fixture(markup, name)
    fixture_path = File.join("#{Rails.root}/../spec/javascripts/fixtures")
    Dir.mkdir(fixture_path) unless File.exists?(fixture_path)

    fixture_file = File.join(fixture_path, "#{name}.html")
    File.open(fixture_file, 'w') do |file|
      file.puts(markup)
    end
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures = false
end
