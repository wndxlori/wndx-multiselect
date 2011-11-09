describe("WNDX.Multiselect", function() {

    var multiSelect;

    beforeEach(function() {
        loadFixtures('multiselect_tag.html');
        multiSelect = new WNDX.Multiselect($('div.multiselect'));
        multiSelect.initialize();
        multiSelect.resetLinks();
    });

    it("should initialize itself", function() {
        expect(multiSelect.holder).toEqual($('div.multiselect'));
    });

    it("should set a data reference so that the object can be retrieved", function() {
        expect($('div.multiselect').data('multiselect')).toBe( multiSelect );
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
        multiSelect.resetLinks();
        $('a.add').click();
        // check for option in selected with val matching original
        expect($('#field_name_selected option:first').val()).toEqual(opt_val);
    });

    it("should remove selected items from the match list", function() {
        // get val of first option
        var opt_val = $('#field_name_match option:first').val();
        var opt_cnt = $('#field_name_match option').length;

        // select first option
        $('#field_name_match option:first').attr('selected', true);
        // click on add button
        multiSelect.resetLinks();
        $('a.add').click();

        // check for no option in matched with val matching original
        expect($('#field_name_match option').length).toBe(opt_cnt-1);
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

    it("after selecting all items the match list should be empty", function() {
        var opt_cnt = $('#field_name_match option').length;

        $('a.all[name=match2selected]').click();

        expect($('#field_name_match option').length).toBe(0);
        expect($('#field_name_selected option').length).toBe(opt_cnt);
    });

    it("should remove one or more items", function() {
        // Moves everything into selected
        $('a.all[name=match2selected]').click();
        // get val of first option
        var opt_val = $('#field_name_selected option:first').val();
        // select first option
        $('#field_name_selected option:first').attr('selected', true);
        // click on add button
        multiSelect.resetLinks();
        $('a.remove').click();
        // check for option in selected with val matching original
        expect($('#field_name_match option:first').val()).toEqual(opt_val);
    });

    it("should remove selected items from the selected list", function() {
        // Moves everything into selected
        $('a.all[name=match2selected]').click();

        // get val of first option
        var opt_val = $('#field_name_selected option:first').val();
        var opt_cnt = $('#field_name_selected option').length;

        // click on add button
        $('#field_name_selected option:first').attr('selected', true);
        multiSelect.resetLinks();
        $('a.remove').click();

        // check for no option in matched with val matching original
        expect($('#field_name_selected option').length).toBe(opt_cnt-1);
        $('#field_name_selected option').each( function(){
            expect($(this).val()).toNotEqual(opt_val);
        } );
    });

    it("should remove all items", function() {
        // Moves everything into selected
        $('a.all[name=match2selected]').click();
        // click on add all button
        multiSelect.resetLinks();
        $('a.all[name=selected2match]').click();
        // Make sure the selected select has been emptied
        expect($('#field_name_selected option').size()).toEqual(0);
        // Make sure the match select has been filled
        expect($('#field_name_match option').size()).toEqual(3);
    });

    it("after removing all items the selected list should be empty", function() {
        $('a.all[name=match2selected]').click();
        multiSelect.resetLinks();
        $('a.all[name=selected2match]').click();

        expect($('#field_name_selected option').length).toBe(0);
    });

    it("should have selected ids for selected items", function() {
        // get val of first option
        var opt_val = $('#field_name_match option:first').val();
        // select first option
        $('#field_name_match option:first').attr('selected', true);
        // click on add button
        multiSelect.resetLinks();
        $('a.add').click();
        // Checks value of hidden ids
        expect($('input[type=hidden]').val()).toEqual(opt_val);
    });

    // Not going to test the autocomplete stuff here.  Assuming it works
});