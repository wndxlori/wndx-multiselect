describe("WNDX.AutocompleteMultiselect", function() {

    var autocompleteMultiSelect;

    beforeEach(function() {
        loadFixtures('autocomplete_multiselect_tag.html');
        var container = $('div.multiselect:first');
        autocompleteMultiSelect = new WNDX.Multiselect(container);
        autocompleteMultiSelect.initialize();
    });

    it("should have selected ids for selected items", function() {
        spyOn(jQuery.prototype, 'autocomplete');

        autocompleteMultiSelect.setSearch('Foo');

        expect(jQuery.prototype.autocomplete).toHaveBeenCalledWith('search', 'Foo');
        expect($('input.multiselecttext')).toHaveValue('Foo');
    });

});


