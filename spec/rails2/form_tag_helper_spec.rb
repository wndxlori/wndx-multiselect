require 'spec_helper'

describe ActionView::Helpers::FormTagHelper, :type => :helper do

  describe "multiselect_tag" do

    it_should_behave_like 'multiselect_core'

    before(:each) do
      @control = helper.multiselect_tag('field_name', options_for_select({:name1=>"1", :name2=>"2", :name3=>"3"}))
    end

    after(:all) do
      save_fixture(@control, 'multiselect_tag')
    end

  end

  describe "autocomplete_multiselect_tag" do

    it_should_behave_like 'multiselect_core'

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
