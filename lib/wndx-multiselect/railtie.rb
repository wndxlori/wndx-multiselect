module WndxMultiselect
  class Railtie < Rails::Railtie
    initializer "wndx_multiselect.action_view" do |app|
      ActiveSupport.on_load :action_view do
        begin
          require 'rails3-jquery-autocomplete'
        rescue LoadError
          puts 'PowerUX Multiselect requires the rails3-jquery-autocomplete gem'
        end
        require 'wndx-multiselect/support'
        require 'wndx-multiselect/form_tag_helper'
        require 'wndx-multiselect/form_helper'
#        ActionView::Helpers.send(:include, WndxMultiselect::FormHelper )
#        ActionView::Helpers.send(:include, WndxMultiselect::FormTagHelper ) 
        include WndxMultiselect::Support
        include WndxMultiselect::FormHelper
        include WndxMultiselect::FormTagHelper
      end
    end
  end
end