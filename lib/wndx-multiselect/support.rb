#
# Methods shared by the controller and helpers for WNDX Multiselect
#
module WndxMultiselect
  module Support
    # Returns a limit that will be used on the query
    def get_autocomplete_limit(options)
      options[:limit] ||= 10
    end
    # Returns parameter model_sym as a constant
    #
    # get_object(:actor)
    # # returns a Actor constant supposing it is already defined
    #
    def get_object(model_sym)
      model_sym.to_s.camelize.constantize
    end

    def get_keys_from(model_sym)
      key = get_object(model_sym).send( :primary_key )
      if [String,Symbol].include?( key.class )
        key.to_s
      else # composite primary key
        key.join('_')
      end
    end

    def get_autocomplete_order(method, options, model=nil)
      order = options[:order]

      table_prefix = model ? "#{model.table_name}." : ""
      order || "#{table_prefix}#{method} ASC"
    end

    def get_autocomplete_items(parameters)
      model = parameters[:model]
      term = parameters[:term]
      method = parameters[:method]
      options = parameters[:options]

      find_options = {
        :conditions => get_autocomplete_where_clause(model, term, method, options),
        :order => get_autocomplete_order(method, options, model),
        :limit => get_autocomplete_limit(options)
      }

      find_options[:select] = get_autocomplete_select_clause(model, method, options).join(', ') unless options[:full_model]

      model.all(find_options)
    end

    def get_autocomplete_select_clause(model, method, options)
      table_name = model.table_name
      selects = []
      selects << "#{table_name}.#{model.primary_key}"
      selects << "#{table_name}.#{method}"
      options[:extra_data].split(',').inject(selects) do |selects,extra|
        selects << "#{table_name}.#{extra}"
      end unless options[:extra_data].blank?
      selects
    end

    def get_autocomplete_where_clause(model, term, method, options)
      table_name = model.table_name
      is_full_search = options[:full]
      ["LOWER(#{table_name}.#{method}) LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]
    end
  end
end