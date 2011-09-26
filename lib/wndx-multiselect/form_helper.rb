module ActionView
  module Helpers

    module FormHelper

      include WndxMultiselect::Support

      # select(object, method, choices, options = {}, html_options = {})
      def multiselect(object, method, ids, options ={})
        name = "#{object}_#{method}"
        matches = options_for_multiselect_match(object, method, "", options)
        selects = options_for_multiselect_selected(object, method, ids, options)
        generate_multiselect_tag(name, nil, matches, selects, nil, options)
      end

      def autocomplete_multiselect(object, method, value, ids, source, options = {})
        name = "#{object}_#{method}"
        matches = options_for_multiselect_match(object, method, value, options)
        selects = options_for_multiselect_selected(object, method, ids, options)
        generate_multiselect_tag(name, value, matches, selects, source, options)
      end

      # Finds items where method matches the match text, creates option_tag for each
      def options_for_multiselect_match( object, method, match = "", options = {} )
        #allow specifying fully qualified class name for model object
        class_name = options[:class_name] || object
        model = get_object(class_name)
        items = get_autocomplete_items(:model => model, :options => options, :term => match, :method => method)
        options_from_collection_for_select(items, :to_param, method)
      end

      # Finds items by id, creates option tag for each
      def options_for_multiselect_selected( object, method, ids, options = {} )
        return [] if ( ids.nil? or ids.empty? )
        class_name = options[:class_name] || object
        model = get_object(class_name)
        items = get_selected_items(:model => model, :options => options, :ids => ids, :method => method)
        options_from_collection_for_select(items, :to_param, method)
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
          :conditions => get_selected_where_clause(model, selected_ids, method, options),
          :order => get_autocomplete_order(method, options, model),
          :limit => get_autocomplete_limit(options)
        }

        find_options[:select] = get_autocomplete_select_clause(model, method, options).join(', ') unless options[:full_model]

        model.all(find_options)

      end

      def get_selected_where_clause(model, ids, method, options)
        table_name = model.table_name
        ["#{table_name}.#{model.primary_key} IN (?)", ids]
      end
    end
  end
end
