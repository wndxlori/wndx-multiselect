describe "multiselect_core", :shared => true do

  it "should have a match select box" do
    @control.should have_tag('select.multiselectmatch')
  end

  it "should have a selected select box" do
    @control.should have_tag('select.multiselectselected')
  end

  ['Add', 'Add All', 'Remove', 'Remove All'].each do |button_value|
    it "should have an #{button_value} button" do
      @control.should have_tag("a", button_value)
    end
  end

  it "should have hidden field tag" do
    @control.should have_tag("input[type=hidden]")
  end

end
