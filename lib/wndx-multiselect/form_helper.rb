module ActionView
  module Helpers

    module FormHelper

      include WndxMultiselect::Support

      # select(object, method, choices, options = {}, html_options = {})
      def multiselect(object, method, ids, options ={})
        name = "#{object}_#{method}"
        unless options[:empty]
          matches = options_for_multiselect_match(object, method, "", options)
          selects = options_for_multiselect_selected(object, method, ids, options)
        else
          matches = ''
          selects = ''
        end
        generate_multiselect_tag(name, nil, matches, selects, nil, options)
      end

      def autocomplete_multiselect(object, method, source, options = {})
        instance_var = self.instance_variable_get("@#{object}")
        unless options[:empty]
          value   = instance_var.send(method)
          ids     = instance_var.send(:selected_ids)
          matches = options_for_multiselect_match(object, method, value, options)
          selects = options_for_multiselect_selected(object, method, ids, options)
        else
          value   = ''
          matches = ''
          selects = ''
        end
        generate_multiselect(object, method, value, matches, selects, source, options)
      end

      # Finds items where method matches the match text, creates option_tag for each
      def options_for_multiselect_match( object, method, match = "", options = {} )
        #allow specifying fully qualified class name for model object
        class_name = options[:class_name] || object
        model = get_object(class_name)
        items = get_autocomplete_items(:model => model, :options => options, :term => match, :method => method)
        options_from_collection_for_select(items, :to_param, options[:display_value] ||= method)
      end

      # Finds items by id, creates option tag for each
      def options_for_multiselect_selected( object, method, ids, options = {} )
        return [] if ( ids.nil? or ids.empty? )
        class_name = options[:class_name] || object
        model = get_object(class_name)
        items = get_selected_items(:model => model, :options => options, :ids => ids, :method => method)
        options_from_collection_for_select(items, :to_param, options[:display_value] ||= method)
      end

      def autocomplete_field(object_name, method, source, options ={})
        options["data-autocomplete"] = source
        text_field(object_name, method, rewrite_autocomplete_option(options))
      end

    private

      def get_selected_items(parameters)
        ids = parameters[:ids]
        return [] if ( ids.nil? or ids.empty?)
        selected_ids = ids.is_a?(Array) ? ids : ids.split(',')

        model = parameters[:model]
        method = parameters[:method]
        options = parameters[:options]

        find_options = {
          :conditions => get_selected_where_clause(model, selected_ids),
          :order => get_autocomplete_order(method, options, model),
          :limit => get_autocomplete_limit(options)
        }

        find_options[:select] = get_autocomplete_select_clause(model, method, options).join(', ') unless options[:full_model]

        model.all(find_options)

      end

      def get_selected_where_clause(model, ids)
        table_name = model.table_name
        ["#{table_name}.#{model.primary_key} IN (?)", ids]
      end

      def generate_multiselect(object, method, value, matches, selects, source, options={})
        options[:multiselect] = source unless source.nil?
        updated_options = rename_multiselect_option(options)
        select_match_options = add_match_options(updated_options)
        select_selected_options = add_selected_options(updated_options)
        text_options = add_text_options(updated_options)
        hidden_options = add_hidden_options(updated_options)

        name = "#{object.to_s}[#{method.to_s}]"

        button_tags = []
        button_tags << link_to_function( content_tag(:span, 'Add'), {}, :name => 'match2selected', :class => 'add', :alt => 'Add')
        button_tags << link_to_function( content_tag(:span, 'Add All'), {}, :name => 'match2selected', :class => 'all', :alt => 'Add All')
        button_tags << link_to_function( content_tag(:span, 'Remove'), {}, :name => 'selected2match', :class => 'remove', :alt => 'Remove')
        button_tags << link_to_function( content_tag(:span, 'Remove All'), {}, :name => 'selected2match', :class => 'all', :alt => 'Remove All')
        buttons = content_tag( :div, button_tags.join(tag(:br)), :class => 'multiselectbuttons')
#        buttons = content_tag( :div, raw(button_tags.join(tag(:br))), :class => 'multiselectbuttons')

        select_tags = []
        select_tags << text_field( object, method, text_options.merge(:value => value) ) unless source.nil?
        select_tags << select_tag( object.to_s + "_match", matches, select_match_options)
        select_tags << buttons
        select_tags << select_tag( object.to_s + "_selected", selects, select_selected_options)
        select_tags << hidden_field( object, :selected_ids, hidden_options )

        content_tag(:div, select_tags.join, updated_options.merge(:class => 'multiselect'))
#        content_tag(:div, raw(selects.join), updated_options.merge(:class => 'multiselect'))
      end
    end
  end
end
