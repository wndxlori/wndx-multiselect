require 'spec_helper'
require "multiselect_core_shared"

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

    before(:each) do
      @control = helper.multiselect(:matches, :name, [])
    end

    it_should_behave_like 'multiselect_core'

    describe "options_for_multiselect_match" do

      it "should find all items if no match text provided" do
        Matches.should_receive(:all).
            with({:select=>"match.id, match.name", :order=>"match.name ASC", :limit=>50}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name)
      end

      it "should find the limit specified number of items" do
        Matches.should_receive(:all).
            with({:conditions=>["LOWER(match.name) LIKE ?", "%foo%"], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>20}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name, "foo", :limit => 20)
      end

      it "should find items in the order specified" do
        Matches.should_receive(:all).
            with({:conditions=>["LOWER(match.name) LIKE ?", "%foo%"], :select=>"match.id, match.name", :order=>"id DESC", :limit=>50}).
            and_return(@items)
        @matches = helper.options_for_multiselect_match(:matches, :name, "foo", :order => 'id DESC')
      end

    end

    describe "options_for_multiselect_selected" do

      it "should find items with ids in a string" do
        Matches.should_receive(:all).
            with({:conditions=>["match.id IN (?)", %w(1 2 3)], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>50}).
            and_return(@items)
        @matches = helper.options_for_multiselect_selected( :matches, :name, "1,2,3" )
      end

      it "should find items with ids in an array" do
        Matches.should_receive(:all).
            with({:conditions=>["match.id IN (?)", %w(1 2 3)], :select=>"match.id, match.name", :order=>"match.name ASC", :limit=>50}).
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

  describe "multiselect with :empty option" do

    it "should not query the list of matches" do
      Matches.should_not_receive(:all)
      @control = helper.multiselect(:matches, :name, [], :empty => true)
    end

  end

  describe "autocomplete_multiselect" do

    before(:each) do
      @matches = mock(:name => 'Foo', :selected_ids => [] )
      assigns[:matches] = @matches
      @control = helper.autocomplete_multiselect(:matches, :name, 'some/path')
    end

    it_should_behave_like 'multiselect_core'

    it "should have an autocomplete text field tag" do
      @control.should have_tag("input.multiselecttext[type=text]")
    end

    after(:all) do
      save_fixture(@control, 'autocomplete_multiselect')
    end

  end

  describe "autocomplete_multiselect with :empty option" do

    def create
      @control = helper.autocomplete_multiselect(:matches, :name, 'some/path', :empty => true)
    end

    before(:each) do
      @matches = mock(:name => 'Foo', :selected_ids => [1,2,3] )
      assigns[:matches] = @matches
    end

    it "should not query the search value" do
      @matches.should_not_receive(:name)
      create
    end

    it "should not query the list of matches" do
      Matches.should_not_receive(:all)
      create
    end

    it "should not query the list of ids" do
      @matches.should_not_receive(:selected_ids)
      create
    end

  end

  describe "autocomplete_multiselect with style option" do

    before(:each) do
      @matches = mock(:name => 'Foo', :selected_ids => [1,2,3] )
      assigns[:matches] = @matches
      @control = helper.autocomplete_multiselect(:matches, :name, 'some/path', :style=>'foo=bar')
    end

    it "the outer div should have the style" do
      @control.should have_tag('div.multiselect[style="foo=bar"]')
    end

    it "the inner elements should not have the style" do
      @control.should_not have_tag('select.multiselectmatch[style="foo=bar"]')
      @control.should_not have_tag('select.multiselectselected[style="foo=bar"]')
      @control.should_not have_tag('input.multiselecttext[style="foo=bar"]')
      @control.should_not have_tag('input.multiselectids[style="foo=bar"]')
      @control.should_not have_tag('a[style="foo=bar"]')
    end

  end

  describe "autocomplete_multiselect with custom id" do

    before(:each) do
      @matches = mock(:name => 'Foo', :selected_ids => [1,2,3] )
      assigns[:matches] = @matches
      @control = helper.autocomplete_multiselect(:matches, :name, 'some/path', :id=>'foo')
    end

    it "the outer div should have the id" do
      @control.should have_tag('div#foo')
    end

    it "the inner elements should have derived ids" do
      @control.should have_tag('select.multiselectmatch#foo_match')
      @control.should have_tag('select.multiselectselected#foo_selected')
      @control.should have_tag('input.multiselecttext#foo_text')
      @control.should have_tag('input.multiselectids#foo_hidden')
    end

  end

end
