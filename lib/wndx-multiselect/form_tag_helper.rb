# Builders for the multiselect controls

module ActionView
  module Helpers

    module FormTagHelper

      # select_tag(name, option_tags = nil, options = {})
      def multiselect_tag(name, option_tags, options ={})
        generate_multiselect_tag( name, nil, option_tags, nil, nil, options )
      end
    
      def autocomplete_multiselect_tag(name, match, source, options ={})
        generate_multiselect_tag( name, match, nil, nil, source, options )
      end
    
      def autocomplete_field_tag(name, value, source, options ={})
        options["data-autocomplete"] = source
        text_field_tag(name, value, rewrite_autocomplete_option(options))
      end

    private

      def add_match_options( options = {} )
        options = options.merge( :multiple => true, :size => 7, :class => 'multiselectmatch').except(:style)
        options[:id] = options[:id].to_s + '_match' if options[:id]
        options
      end

      def add_selected_options( options = {} )
        options = options.merge( :multiple => true, :size => 7, :class => 'multiselectselected').except(:style)
        options[:id] = options[:id].to_s + '_selected' if options[:id]
        options
      end

      def add_text_options( options = {} )
        options = options.merge(:class => 'multiselecttext', :placeholder => 'Enter match text').except(:style)
        options[:id] = options[:id].to_s + '_text' if options[:id]
        options
      end

      def add_hidden_options( options = {} )
        options = options.merge( :class => 'multiselectids' ).except(:style)
        options[:id] = options[:id].to_s + '_hidden' if options[:id]
        options[:value]="" if options[:empty]
        options
      end

      #
      # Method used to rename the multiselect key to a more standard
      # data-multiselect key
      #
      def rename_multiselect_option(options)
        options["data-multiselect"] = options.delete(:multiselect)
        options
      end
    
      def generate_multiselect_tag(name, match, matches, selects, source, options={})
        options[:multiselect] = source unless source.nil?
        updated_options = rename_multiselect_option(options)
        select_match_options = add_match_options(updated_options)
        select_selected_options = add_selected_options(updated_options)
        text_options = add_text_options(updated_options)
        hidden_options = add_hidden_options(updated_options)

        button_tags = []
        button_tags << link_to_function( content_tag(:span, 'Add'), {}, :name => 'match2selected', :class => 'add', :alt => 'Add')
        button_tags << link_to_function( content_tag(:span, 'Add All'), {}, :name => 'match2selected', :class => 'all', :alt => 'Add All')
        button_tags << link_to_function( content_tag(:span, 'Remove'), {}, :name => 'selected2match', :class => 'remove', :alt => 'Remove')
        button_tags << link_to_function( content_tag(:span, 'Remove All'), {}, :name => 'selected2match', :class => 'all', :alt => 'Remove All')
        buttons = content_tag( :div, button_tags.join(tag(:br)), :class => 'multiselectbuttons')
#        buttons = content_tag( :div, raw(button_tags.join(tag(:br))), :class => 'multiselectbuttons')

        select_tags = []
        select_tags << text_field_tag( 'match', match, text_options) unless source.nil?
        select_tags << select_tag( name.to_s + "_match", matches, select_match_options)
        select_tags << buttons
        select_tags << select_tag( name.to_s + "_selected", selects, select_selected_options)
        select_tags << hidden_field_tag( "#{name.to_s}_ids[]", nil, hidden_options )

        content_tag(:div, select_tags.join, updated_options.merge(:class => 'multiselect'))
#        content_tag(:div, raw(selects.join), updated_options.merge(:class => 'multiselect'))
      end
    end
  end
end
