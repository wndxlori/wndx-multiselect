describe("WNDX.AutocompleteMultiselect", function() {

    var autocompleteMultiSelect;

    beforeEach(function() {
        loadFixtures('autocomplete_multiselect_tag.html');
        autocompleteMultiSelect = new WNDX.Multiselect($('div.multiselect').first);
        autocompleteMultiSelect.initialize();
    });
});
