#
# This is a retrofitted version of the Rails3JQueryAutoComplete plugin code, altered
# to work with Rails 2.x
#
# See: https://github.com/crowdint/rails3-jquery-autocomplete
#
module Rails2jQueryAutoComplete
  
  def self.included(base)
    base.extend(Rails2jQueryAutoComplete::ClassMethods)
  end

  #
  # Usage:
  #
  # class ProductsController < Admin::BaseController
  # autocomplete :brand, :name
  # end
  #
  # This will magically generate an action autocomplete_brand_name, so,
  # don't forget to add it on your routes file
  #
  # map.resources :products, :collection => {:autocomplete_brand_name => :get}
  #
  # Now, on your view, all you have to do is have a text field like:
  #
  # Yajl is used by default to encode results, if you want to use a different encoder
  # you can specify your custom encoder via block
  #
  # class ProductsController < Admin::BaseController
  # autocomplete :brand, :name do |items|
  # CustomJSONEncoder.encode(items)
  # end
  # end
  #
  module ClassMethods
    def autocomplete(object, method, options = {})
      define_method("autocomplete_#{object}_#{method}") do

        method = options[:column_name] if options.has_key?(:column_name)

        term = params[:term]

        if term && !term.blank?
          #allow specifying fully qualified class name for model object
          class_name = options[:class_name] || object
          items = get_autocomplete_items(:model => get_object(class_name), \
            :options => options, :term => term, :method => method)
        else
          items = {}
        end

        render :json => json_for_autocomplete(items, options[:display_value] ||= method, options[:extra_data])
      end
    end
  end

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
    object = model_sym.to_s.camelize.constantize
  end

  #
  # Returns a hash with three keys actually used by the Autocomplete jQuery-ui
  # Can be overriden to show whatever you like
  # Hash also includes a key/value pair for each method in extra_data
  #
  def json_for_autocomplete(items, method, extra_data=[])
    items.collect do |item|
      hash = {"id" => item.id.to_s, "label" => item.send(method), "value" => item.send(method)}
      extra_data.each do |datum|
        hash[datum] = item.send(datum)
      end if extra_data
      # TODO: Come back to remove this if clause when test suite is better
      hash
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
    (["#{table_name}.#{model.primary_key}", "#{table_name}.#{method}"] + (options[:extra_data].blank? ? [] : options[:extra_data]))
  end

  def get_autocomplete_where_clause(model, term, method, options)
    table_name = model.table_name
    is_full_search = options[:full]
    ["LOWER(#{table_name}.#{method}) LIKE ?", "#{(is_full_search ? '%' : '')}#{term.downcase}%"]
  end
end
