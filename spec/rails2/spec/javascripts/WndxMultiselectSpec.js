describe("WNDX.Multiselect", function() {

    var multiSelect;

    beforeEach(function() {
        loadFixtures('multiselect_tag.html');
        multiSelect = new WNDX.Multiselect($('div.multiselect'));
        multiSelect.initialize();
    });

    it("should initialize itself", function() {
        expect(multiSelect.holder).toEqual($('div.multiselect'));
    });

    it("should initialize links", function() {
        expect($('a.remove.disabled')).toExist();
        expect($('a.all.disabled[name=selected2match]')).toExist();
    });

    it("should select one or more items", function() {
        // get val of first option
        var opt_val = $('#field_name_match option:first').val();
        // select first option
        $('#field_name_match option:first').attr('selected', true);
        // click on add button
        $('a.add').click();
        // check for option in selected with val matching original
        expect($('#field_name_selected option:first').val()).toEqual(opt_val);
    });

    it("should remove selected items from the match list", function() {
        // get val of first option
        var opt_val = $('#field_name_match option:first').val();
        // select first option
        $('#field_name_match option:first').attr('selected', true);
        // click on add button
        $('a.add').click();
        // check for no option in matched with val matching original
        $('#field_name_match option').each( function(){
            expect($(this).val()).toNotEqual(opt_val);
        } );
    });

    it("should select all items", function() {
        // click on add all button
        $('a.all[name=match2selected]').click();
        // Make sure the match select has been emptied
        expect($('#field_name_match option').size()).toEqual(0);
        // Make sure the selected select has been filled
        expect($('#field_name_selected option').size()).toEqual(3);
    });

    it("should remove one or more items", function() {
        // Moves everything into selected
        $('a.all[name=match2selected]').click();
        // get val of first option
        var opt_val = $('#field_name_selected option:first').val();
        // select first option
        $('#field_name_selected option:first').attr('selected', true);
        // click on add button
        $('a.remove').click();
        // check for option in selected with val matching original
        expect($('#field_name_match option:first').val()).toEqual(opt_val);
    });

    it("should remove all items", function() {
        // Moves everything into selected
        $('a.all[name=match2selected]').click();
        // click on add all button
        $('a.all[name=selected2match]').click();
        // Make sure the selected select has been emptied
        expect($('#field_name_selected option').size()).toEqual(0);
        // Make sure the match select has been filled
        expect($('#field_name_match option').size()).toEqual(3);
    });

    it("should have selected ids for selected items", function() {
        // get val of first option
        var opt_val = $('#field_name_match option:first').val();
        // select first option
        $('#field_name_match option:first').attr('selected', true);
        // click on add button
        $('a.add').click();
        // Checks value of hidden ids
        expect($('input[type=hidden]').val()).toEqual(opt_val);
    });

    // Not going to test the autocomplete stuff here.  Assuming it works
});