require 'rails/generators'

class WndxMultiselectGenerator < Rails::Generators::Base
  desc "Run this generator to enable WNDX Multiselect in your Rails application"

  source_root File.join(File.dirname(__FILE__), 'templates')
  
  def install
    # Copy the unobtrusive JS file
    copy_file('wndx-multiselect-busy.gif', 'public/images/wndx/multiselect-busy.gif')

    %w(16 32).each do |size|
      copy_file("#{size}/plain/navigate_left.png", "public/images/wndx/#{size}/plain/navigate_left.png")
      copy_file("#{size}/plain/navigate_left2.png", "public/images/wndx/#{size}/plain/navigate_left2.png")
      copy_file("#{size}/shadow/navigate_left.png", "public/images/wndx/#{size}/shadow/navigate_left.png")
      copy_file("#{size}/shadow/navigate_left2.png", "public/images/wndx/#{size}/shadow/navigate_left2.png")
      copy_file("#{size}/plain/navigate_right.png", "public/images/wndx/#{size}/plain/navigate_right.png")
      copy_file("#{size}/plain/navigate_right2.png", "public/images/wndx/#{size}/plain/navigate_right2.png")
      copy_file("#{size}/shadow/navigate_right.png", "public/images/wndx/#{size}/shadow/navigate_right.png")
      copy_file("#{size}/shadow/navigate_right2.png", "public/images/wndx/#{size}/shadow/navigate_right2.png")
    end
    copy_file('wndx-multiselect.css', 'public/stylesheets/wndx/multiselect.css')
    
    copy_file('wndx-multiselect-rails.js', 'public/javascripts/wndx-multiselect-rails.js')
  end
  
  # def manifest
  #   puts "Installing"
  #   record do |m|
  #     m.file 'wndx-multiselect-rails.js',
  #            'public/javascripts/wndx-multiselect-rails.js',
  #            :collision => :ask
  # 
  #     m.file 'wndx-multiselect.css',
  #            'public/stylesheets/wndx/multiselect.css',
  #            :collision => :ask
  #   end
  # end
end
