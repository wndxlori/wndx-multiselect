require 'spec_helper'

describe "multiselect", :shared => true do

  it "should have a match select box" do
    @control.should have_tag('select.multiselectmatch')
  end

  it "should have a selected select box" do
    @control.should have_tag('select.multiselectselected')
  end

  ['Add', 'Add All', 'Remove', 'Remove All'].each do |button_value|
    it "should have an #{button_value} button" do
      @control.should have_tag("input[type=submit][value=#{button_value}]")
    end
  end

  it "should have hidden field tag" do
    @control.should have_tag("input[type=hidden]")
  end

end

describe ActionView::Helpers::FormTagHelper, :type => :helper do

  describe "multiselect_tag" do

    it_should_behave_like 'multiselect'

    before(:each) do
      @control = helper.multiselect_tag('field_name', [], '')
    end

    after(:all) do
      save_fixture(@control, 'multiselect_tag')
    end

  end

  describe "autocomplete_multiselect_tag" do

    it_should_behave_like 'multiselect'

    before(:each) do
      @control = helper.autocomplete_multiselect_tag('field_name', '', 'some/path')
    end

    it "should have an autocomplete text field tag" do
      @control.should have_tag("input.multiselecttext[type=text]")
    end

    after(:all) do
      save_fixture(@control, 'autocomplete_multiselect_tag')
    end

  end
end 
