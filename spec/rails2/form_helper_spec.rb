require 'spec_helper'

describe ActionView::Helpers::FormHelper, :type => :helper do

  class Matches
    def self.table_name; 'match' end
    def self.primary_key; 'id' end
  end

  before(:all) do
    @items = [OpenStruct.new({:id => 1, :name => 'foobar'})]
  end

  before(:each) do
    Matches.stub!(:all).and_return(@items)
  end

  describe "multiselect" do

    it_should_behave_like 'multiselect_core'

    before(:each) do
      @control = helper.multiselect(:matches, :name, [])
    end


    describe "options_for_multiselect_match" do

      it "should find all items if no match text provided" do
        Matches.should_receive(:all).
            with({:conditions=>["LOWER(match.name) LIKE ?", "%"], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>10}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name)
      end

      it "should find the limit specified number of items" do
        Matches.should_receive(:all).
            with({:conditions=>["LOWER(match.name) LIKE ?", "foo%"], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>20}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name, "foo", :limit => 20)
      end

      it "should find items in the order specified" do
        Matches.should_receive(:all).
            with({:conditions=>["LOWER(match.name) LIKE ?", "foo%"], :select=>"match.id, match.name", :order=>"id DESC", :limit=>10}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name, "foo", :order => 'id DESC')
      end

    end

    describe "options_for_multiselect_selected" do
      it "should find items with ids in a string" do
        Matches.should_receive(:all).
            with({:conditions=>["match.id in (?)", %w(1 2 3)], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>10}).
            and_return(@items)
        @matches = helper.options_for_multiselect_selected( :matches, :name, "1,2,3" )
      end

      it "should find items with ids in an array" do
        Matches.should_receive(:all).
            with({:conditions=>["match.id in (?)", %w(1 2 3)], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>10}).
            and_return(@items)
        @matches = helper.options_for_multiselect_selected( :matches, :name, %w(1 2 3) )
      end

      it "should not fail, if no ids are provided" do
        @matches = helper.options_for_multiselect_selected( :matches, :name, "" )
        @matches.size.should == 0
        @matches = helper.options_for_multiselect_selected( :matches, :name, [] )
        @matches.size.should == 0
      end

    end

    after(:all) do
      save_fixture(@control, 'multiselect')
    end

  end

  describe "autocomplete_multiselect" do

    it_should_behave_like 'multiselect_core'

    before(:each) do
      @control = helper.autocomplete_multiselect(:matches, :name, "foo", %w(1 2 3), 'some/path')
    end

    it "should have an autocomplete text field tag" do
      @control.should have_tag("input.multiselecttext[type=text]")
    end

    after(:all) do
      save_fixture(@control, 'autocomplete_multiselect')
    end

  end
end
