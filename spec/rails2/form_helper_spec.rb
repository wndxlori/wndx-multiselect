require 'spec_helper'
require 'wndx-multiselect/form_helper'

describe ActionView::Helpers::FormTagHelper do
  
  describe "multiselect_control_tag" do
    before(:each) do
      @control = multiselect_control_tag('field_name', [], '', :multiselect => 'some/path')
    end
    
    it "should have a left select box" do
      @control.should have_tag('select')
    end
    
    it "should have a right select box" do
      pending
    end
    
    it "should have an add button" do
      pending
    end
    
    it "should have an add all button" do
      pending
    end
    
    it "should have hidden field tag with given name" do
      pending
    end
    
  end
end 
