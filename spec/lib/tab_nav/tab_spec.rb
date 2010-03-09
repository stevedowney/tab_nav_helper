require File.dirname(__FILE__) + '/../../spec_helper'

describe TabNav::Tab do
  
  before(:each) do
    @template = ActionView::Base.new
    @tab_item = TabNav::Tab.new(:home, '/home')
  end
  
  it "set name" do
    @tab_item.name.should == :home
  end
  
  it "set url" do
    @tab_item.url.should == '/home'
  end
  
  it "should default label" do
    @tab_item.label.should == 'Home'
    TabNav::Tab.new(:home_page, '/home').label.should == 'Home Page'
  end
  
  it "should set label" do
    TabNav::Tab.new(:home_page, '/home', :label => "Foo").label.should == 'Foo'
  end
  
  it "default class" do
    @tab_item.css_class.should == 'tab-item'
  end
  
  it "should add classes" do
    TabNav::Tab.new(:home, '/home', :css_class => 'foo').css_class.should == 'tab-item foo'
    TabNav::Tab.new(:home, '/home', :css_class => %w(foo bar)).css_class.should == 'tab-item foo bar'
  end
  
  it "default dom id" do
    @tab_item.dom_id.should == 'tab-home'
  end
  
  it "should set dom id" do
    TabNav::Tab.new(:home, '/home', :dom_id => 'foo').dom_id.should == 'foo'
  end
  
  describe 'html' do
    
    it "should html" do
      @tab_item.tab_set = TabNav::TabSet.new(@template, :name)
      @tab_item.html.should == %(<li class="tab-item" id="tab-home"><a href="/home">Home</a></li>)
    end
    
  end
  
end