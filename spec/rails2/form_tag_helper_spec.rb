require 'spec_helper'
require "multiselect_core_shared"

describe ActionView::Helpers::FormTagHelper, :type => :helper do

  describe "multiselect_tag" do

    before(:each) do
      @control = helper.multiselect_tag('field_name', options_for_select({:name1=>"1", :name2=>"2", :name3=>"3"}))
    end

    it_should_behave_like 'multiselect_core'

    after(:all) do
      save_fixture(@control, 'multiselect_tag')
    end

  end

  describe "autocomplete_multiselect_tag" do

    before(:each) do
      @control = helper.autocomplete_multiselect_tag('field_name', '', 'some/path')
    end

    it_should_behave_like 'multiselect_core'

    it "should have an autocomplete text field tag" do
      @control.should have_tag("input.multiselecttext[type=text]")
    end

    after(:all) do
      save_fixture(@control, 'autocomplete_multiselect_tag')
    end

  end

end 
