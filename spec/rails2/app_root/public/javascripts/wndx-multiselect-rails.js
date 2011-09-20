/*
* Unobtrusive multiselect with autocomplete
*
* To use it, you just have to include the HTML attribute data-multiselect
* with the autocomplete URL as the value
*
*/

(function( WNDX, $, undefined ) {

    WNDX.Multiselect = function(container) {
        this.holder = container;
        this.selected_ids = $(container).find('input:hidden');
        this.match_text = $(container).find('input.multiselecttext');
    };

    WNDX.Multiselect.prototype.selectClick = function(button) {
        var arr = $(button).attr("name").split("2");
        var from = arr[0];
        var to = arr[1];
        var holder = $(this.holder);
        var to_select = holder.find("select.multiselect" + to);

        // Chooses selected options or all options
        var option_selector = ' option:selected';
        if ( $(button).hasClass('all')) {
            option_selector = ' option';
        }

        // Moves options from one list to the other list
        holder.find("select.multiselect" + from + option_selector).each(function(){
            var new_option = $(this).clone();
            to_select.append(new_option);
            // Sort "to" list options after new option appended
            to_select.html(holder.find("select.multiselect" + to + " option").sort(function (a, b) {
                return a.text == b.text ? 0 : a.text < b.text ? -1 : 1;
            }));
            $(this).remove(); // TODO: reconsider using detach()
            new_option.effect("highlight", {}, 3000);
        });

       // Saves the id's of selected items in the hidden field
        var ids = new Array();
        holder.find("select.multiselectselected option").each(function(){
            ids.push($(this).val());
        });
        this.selected_ids.val(ids.join(','));

        // to remove items not matching filter
        this.match_text.autocomplete("search");
    };

    WNDX.Multiselect.prototype.autocompleteResponse = function( items ) {
        // From original
        if ( items && items.length ) {
            items = this._normalize( items );
        }
        var div_parent = $(this.element[0]).parent();
        // Empty match list and refill with response items
        var match_select = div_parent.find('select.multiselectmatch');
        match_select.empty();
        $.each(items, function(index, item){
                match_select.
                append($("<option></option>").
                attr("value",item.id).
                text(item.value));
        });

        // Ensures previously selected items don't appear in the match list
        div_parent.find('select.multiselectselected option').each(function(index, item){
            match_select.find("option[value='" + $(this).val() + "']").remove();
        });
        this.element.removeClass( "ui-autocomplete-loading" );
    };

    WNDX.Multiselect.prototype.initialize = function () {
        // Configure event handlers

        var that = this;

        $(this.holder).find('div.multiselectbuttons a').live('click', function(evt) { that.selectClick(this); return false; } );

        $('input[data-multiselect]').live('focus', function(i){
            $(this).autocomplete({
                    minLength: 0,
                    source: $(this).attr('data-multiselect'),
                    focus: function(event, ui) { return false; },
                    select: function( event, ui ) { return false; }
            })
            .data( "autocomplete" )._response = that.autocompleteResponse;
        });
    };
}( window.WNDX = window.WNDX || {}, jQuery ));

