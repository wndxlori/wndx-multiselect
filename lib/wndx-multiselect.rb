require 'wndx-multiselect/form_helper'
require 'wndx-multiselect/auto_complete'

#if defined?(::Rails::Railtie)
#  require 'wndx-multiselect/railtie'
#end

class ActionController::Base
  include ::Rails2jQueryAutoComplete
end