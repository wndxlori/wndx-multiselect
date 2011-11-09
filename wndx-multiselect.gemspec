require './lib/wndx-multiselect/version'
Gem::Specification.new do |s|
  s.name = 'wndx-multiselect'
  s.version = WndxMultiselect::VERSION
  s.summary = "Multiselect control for Rails"
  s.authors = ["Lori M Olson"]
  s.email = ["lori@wndx.com"]
  s.requirements << 'jQuery and jQuery UI Autocomplete'
  s.homepage = 'https://github.com/wndxlori/wndx-multiselect'
  s.files = [
    "lib/wndx-multiselect.rb",
    "lib/generators/templates",
    "lib/generators/templates/wndx-multiselect-busy.gif",
    "lib/generators/templates/wndx-multiselect-rails.js",
    "lib/generators/templates/wndx-multiselect.css",
    "lib/generators/wndx_multiselect_generator.rb",
    "lib/wndx-multiselect/form_helper.rb",
    "lib/wndx-multiselect/railtie.rb",
    "lib/wndx-multiselect/version.rb",
  ]
end