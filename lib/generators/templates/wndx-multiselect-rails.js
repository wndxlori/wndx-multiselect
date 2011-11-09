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
        this.selected_ids = $(container).find('input.multiselectids');
        this.match_text = $(container).find('input.multiselecttext');
        this.add_link = $(container).find('a.add');
        this.remove_link = $(container).find('a.remove');
        this.add_all_link = $(container).find('a.all[name=match2selected]');
        this.remove_all_link = $(container).find('a.all[name=selected2match]');
        this.match_select = $(container).find('select.multiselectmatch');
        this.selected_select = $(container).find('select.multiselectselected');
        //In case we need to get back
        this.holder.data('multiselect', this);
    };

    // When running on iPad, must reconfigure
    WNDX.Multiselect.isiPad = function() {
        return navigator.userAgent.match(/iPad/i);
    };

    WNDX.Multiselect.prototype.noMatchesExist = function() {
        return $(this.match_select).children().size() == 0;
    };

    WNDX.Multiselect.prototype.matchesSelected = function() {
        return $(this.match_select).children(this.selected_selector).size();
    };

    WNDX.Multiselect.prototype.noSelectsExist = function() {
        return $(this.selected_select).children().size() == 0;
    };

    WNDX.Multiselect.prototype.selectsSelected = function() {
        return $(this.selected_select).children(this.selected_selector).size();
    };

    WNDX.Multiselect.prototype.resetLinks = function() {
        if ( this.noMatchesExist() ) {
            this.disableLink(this.add_link);
            this.disableLink(this.add_all_link);
        } else {
            this.enableLink(this.add_all_link);
            if ( this.matchesSelected() ) {
                this.enableLink(this.add_link);
            } else {
                this.disableLink(this.add_link);
            }
        }
        if ( this.noSelectsExist() ) {
            this.disableLink(this.remove_link);
            this.disableLink(this.remove_all_link);
        } else {
            this.enableLink(this.remove_all_link);
            if ( this.selectsSelected() ) {
                this.enableLink(this.remove_link);
            } else {
                this.disableLink(this.remove_link);
            }
        }
        return this;
    };

    WNDX.Multiselect.prototype.enableLink = function(link) {
        $(link).removeClass('disabled');
    };

    WNDX.Multiselect.prototype.disableLink = function(link) {
        $(link).addClass('disabled');
    };

    // Ensure that no options are in both lists
    WNDX.Multiselect.prototype.filter = function() {
        var that = this;

        if (WNDX.Multiselect.isiPad()) {
            $(that.selected_select).children('tr').each( function() {
                $(that.match_select).find("#" + $(this).attr("id")).remove();
            });
        } else {
            $(that.selected_select).children('option').each( function() {
                $(that.match_select).children("option[value='" + $(this).val() + "']").remove();
            });
        }
        return this;
    };

    // Saves the id's of selected items in the hidden field
    WNDX.Multiselect.prototype.saveSelected = function () {
        var ids = new Array();
        if (WNDX.Multiselect.isiPad()) {
            $(this.selected_select).children("tr").each(function(){
                ids.push($(this).attr('id'));
            });
        } else {
            $(this.selected_select).children("option").each(function(){
                ids.push($(this).val());
            });
        }
        this.selected_ids.val(ids.join(','));
        return this;
    };

    WNDX.Multiselect.prototype.iPadSelectClick = function(button) {
        var arr = $(button).attr("name").split("2");
        var from = arr[0];
        var to = arr[1];
        var holder = $(button).parent().parent();
        var to_select = holder.find(".multiselect" + to + " tbody");

        // Chooses selected options or all options
        var row_selector = ' tr.selected';
        if ( $(button).hasClass('all')) {
            row_selector = ' tr';
        }

        // Moves options from one list to the other list
        holder.find(".multiselect" + from + row_selector).each(function(){
            var new_row = $(this).clone();
            to_select.append(new_row);
            // Sort "to" list options after new option appended
            $(this).remove(); // TODO: reconsider using detach()
            new_row.removeClass('selected');
            new_row.effect("highlight", {}, 3000);
        });
        to_select.html(to_select.find("tr").sort(function (a, b) {
            var atext = $(a).find('td:first').text();
            var btext = $(b).find('td:first').text();
            return atext == btext ? 0 : atext < btext ? -1 : 1;
        }));

        this.resetLinks().saveSelected().filter();

        // prevent default click actions
        return false;
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

        this.resetLinks().saveSelected().filter();

        // prevent default click actions
        return false;
    };

    // Reloads the match select
    WNDX.Multiselect.prototype.autocompleteResponse = function( autocomplete, items ) {
        // From original
        if ( items && items.length ) {
            items = autocomplete._normalize( items );
        }
        // Empty match list and refill with response items
        var match_select = this.match_select;
        match_select.empty();
        $.each(items, function(index, item){
            match_select.
                append($("<option></option>").
                attr("value",item.id).
                text(item.value));
        });

        // Ensures previously selected items don't appear in the match list
        $(this.selected_select).children('option').each(function(index, item){
            match_select.find("option[value='" + $(this).val() + "']").remove();
        });
        autocomplete.element.removeClass( "ui-autocomplete-loading" );
        this.resetLinks();
    };

    // Reloads the match table
    WNDX.Multiselect.prototype.ipadAutocompleteResponse = function( autocomplete, items ) {
        // From original
        if ( items && items.length ) {
            items = autocomplete._normalize( items );
        }
        // Empty match list and refill with response items
        var match_table = this.match_select;
        $(match_table).children('tr').remove();
        $.each(items, function(index, item){
            var td = $('<td></td>').text(item.value);
            match_table.append($('<tr></tr>').attr("id", item.id).append(td));
        });

        // Ensures previously selected items don't appear in the match list
        $(this.selected_select).children('tr').each(function(index, item){
            match_table.find("#" + $(this).attr("id")).closest('tr').remove();
        });
        autocomplete.element.removeClass( "ui-autocomplete-loading" );
        this.resetLinks();
    };

    WNDX.Multiselect.replaceSelectWithTable = function(select) {
        var $select = $(select);
        var table = $('<table></table>').attr("class", $select.attr("class")).attr("id", $select.attr("id"));
        var body = $('<tbody></tbody>');
        $select.find('option').each(function (){
            var td = $('<td></td>').text(this.value);
            body.append($('<tr></tr>').attr("id", this.id).append(td));
        });
        $select.after(table.html(body));
        $select.remove();
        return body; // Because the body contains the rows, ok?
    };

    WNDX.Multiselect.prototype.iPadSetup = function() {
        var that = this;
        that.selected_selector = '.selected';
        that.match_select = WNDX.Multiselect.replaceSelectWithTable(that.match_select);
        that.selected_select = WNDX.Multiselect.replaceSelectWithTable(that.selected_select);

        that.resetLinks().saveSelected().filter();

        that.moving = false;
        $(that.holder).find('table').delegate( 'tr', 'touchmove', function(e) { that.moving = true;});
        $(that.holder).find('table').delegate( 'tr', 'touchend', function(e){
            if ( that.moving ) {
                that.moving = false;
                return;
            }
            e.preventDefault();
            $(this).toggleClass('selected');
            that.resetLinks();
        });

        $(that.holder).find('div.multiselectbuttons').addClass('ipad');
        $(that.holder).find('div.multiselectbuttons a').bind('click', function(evt) {
            if ($(this).hasClass('disabled') ) {
                evt.preventDefault();
            } else {
                that.iPadSelectClick(this);
            }
        });

        $(that.match_text).bind('focus', function(i){
            $(this).autocomplete({
                    minLength: 0,
                    source: $(this).attr('data-multiselect'),
                    focus: function(event, ui) { return false; },
                    select: function( event, ui ) { return false; }
            })
            .data( "autocomplete" )._response = function(items) {that.ipadAutocompleteResponse(this, items)};
        });
    };

    WNDX.Multiselect.prototype.stockSetup = function() {
        var that = this;
        that.selected_selector = ':selected';
        that.resetLinks().saveSelected().filter();

        $(that.holder).find('select').bind('change', function() { that.resetLinks(); });

        $(that.holder).find('div.multiselectbuttons a').bind('click', function(evt) {
            if ($(this).hasClass('disabled') ) {
                evt.preventDefault();
            } else {
                that.selectClick(this);
            }
        });

        $(that.match_text).bind('focus', function(i){
            $(this).autocomplete({
                    minLength: 0,
                    source: $(this).attr('data-multiselect'),
                    focus: function(event, ui) { return false; },
                    select: function( event, ui ) { return false; }
            })
            .data( "autocomplete" )._response = function(items) {that.autocompleteResponse(this, items)};
        });
    };

    WNDX.Multiselect.prototype.initialize = function () {
        if (WNDX.Multiselect.isiPad()) {
            this.iPadSetup();
        } else {
            this.stockSetup();
        }
    };

    WNDX.Multiselect.prototype.getSearch = function(value) {
        return this.match_text.val();
    };

    WNDX.Multiselect.prototype.setSearch = function(value) {
        this.match_text.val( value );
        this.match_text.autocomplete('search', value);
    };

    WNDX.Multiselect.prototype.focus = function() {
        this.match_text.focus();
    };

    WNDX.Multiselect.prototype.show = function() {
        this.holder.show();
        this.holder.find(':input').prop('disabled', false);
    };

    WNDX.Multiselect.prototype.hide = function() {
        this.holder.hide();
        this.holder.find(':input').prop('disabled', true);  //Otherwise fields still submit
    };

}( window.WNDX = window.WNDX || {}, jQuery ));

