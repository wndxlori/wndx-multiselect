require 'wndx-multiselect/support'
require 'wndx-multiselect/auto_complete'
require 'wndx-multiselect/form_tag_helper'
require 'wndx-multiselect/form_helper'

#if defined?(::Rails::Railtie)
#  require 'wndx-multiselect/railtie'
#end

class ActionController::Base
  include ::Rails2jQueryAutoComplete
end