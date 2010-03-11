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
    @tab_item.css_class.should be_nil
  end
  
  it "should add classes" do
    TabNav::Tab.new(:home, '/home', :css_class => 'foo').css_class.should == 'foo'
  end
  
  it "default dom id" do
    @tab_item.dom_id.should == 'tab-home'
  end
  
  it "should set dom id" do
    TabNav::Tab.new(:home, '/home', :dom_id => 'foo').dom_id.should == 'foo'
  end
  
  it "should default title" do
    @tab_item.stub!(:current?).and_return(false)
    @tab_item.title.should == 'Go to: /home'
    @tab_item.stub!(:current?).and_return(true)
    @tab_item.title.should == 'You are at: /home'
  end
  
  describe 'html' do
    
    it "not current tab" do
      @template.stub!(:current_tabs).and_return({})
      @tab_item.tab_set = TabNav::TabSet.new(@template)
      @tab_item.html.should == %(<li id="tab-home" title="Go to: /home"><a href="/home">Home</a></li>)
    end
    
    it "current tab as link" do
      @template.stub!(:current_tabs).and_return({:default => :home})
      @tab_item.tab_set = TabNav::TabSet.new(@template)
      expected = %(<li class="tab-item-current" id="tab-home" title="You are at: /home"><a href="/home">Home</a></li>)
      @tab_item.html.should == expected
    end

    it "current tab as text" do
      @template.stub!(:current_tabs).and_return({:default => :home})
      @tab_item.tab_set = TabNav::TabSet.new(@template, :display_current_tab_as_text => true)
      expected =  %(<li class="tab-item-current" id="tab-home" title="You are at: /home"><span>Home</span></li>)
      @tab_item.html.should == expected
    end
    
  end
  
end