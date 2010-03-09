require File.dirname(__FILE__) + '/../../spec_helper'

describe TabNav::TabSet do
  
  before(:each) do
    @template = ActionView::Base.new
    @tab_item = TabNav::Tab.new(:home, '/home')
    @tab_set = TabNav::TabSet.new(@template, :main, [@tab_item])
  end
  
  it "should set template" do
    @tab_set.template.should == @template
  end
  
  it "should raise error if not passed a template" do
    lambda { TabNav::TabSet.new("foo", :main, []) }.should raise_error(ArgumentError)
  end
  
  it "should pass unknown methods to template" do
    @tab_set.content_tag(:span, 'foo').should == "<span>foo</span>"
  end
  
  it "should set name" do
    @tab_set.name.should == :main
  end
  
  it "should set tabs" do
    @tab_set.tabs.should == [@tab_item]
  end
  
  it "should return html" do
    html = @tab_set.html
    open_tag = %(<ul class="tab-set" id="tab-set-main">)
    html.should match(/#{open_tag}/)
  end
end
