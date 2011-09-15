describe("WNDX.Multiselect", function() {

    beforeEach(function() {
        loadFixtures('multiselect.html');
    });

    it("should initialize itself", function() {
        var multiselect = new WNDX.Multiselect($('#select_div')).initialize();
//        $('#collapsed_box a').click();
//        expect($(smartbox.load_link)).toHaveClass('Collapse');
    });

    it("should select one or more items", function() {

    });

    it("should select all items", function() {

    });

    it("should remove one or more items", function() {

    });

    it("should remove all items", function() {

    });

    it("should have selected ids for selected items", function() {

    });

    // Not going to test the autocomplete stuff here.  Assuming it works
});