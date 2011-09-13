require 'rails/generators'

class WndxMultiselectGenerator < Rails::Generators::Base
  desc "Run this generator to enable PowerUX Multiselect in your Rails application"

  source_root File.join(File.dirname(__FILE__), 'templates')
  
  def install
    # Copy the unobtrusive JS file
    copy_file('wndx-multiselect-busy.gif', 'public/images/wndx/multiselect-busy.gif')
    copy_file('wndx-multiselect.css', 'public/stylesheets/wndx/multiselect.css')
    copy_file('wndx-multiselect-rails.js', 'public/javascripts/wndx-multiselect-rails.js')
  end
  
  # def manifest
  #   puts "Installing"
  #   record do |m|
  #     m.file 'wndx-multiselect-rails.js',
  #            'public/javascriptswndx-multiselect-rails.js',
  #            :collision => :ask
  # 
  #     m.file 'wndx-multiselect.css',
  #            'public/stylesheets/wndx/multiselect.css',
  #            :collision => :ask
  #   end
  # end
end
