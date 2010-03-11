require File.dirname(__FILE__) + '/../../spec_helper'

describe TabNav::TabSet do
  before(:each) do
    @template = ActionView::Base.new
  end
  
  describe 'minimalist' do
    before(:each) do
      @tab_set = TabNav::TabSet.new(@template)
    end

    it "should set template" do
      @tab_set.template.should == @template
    end

    it "should raise error if not passed a template" do
      lambda { TabNav::TabSet.new("foo", :main, []) }.should raise_error(ArgumentError)
    end

    it "should set name to :default" do
      @tab_set.name.should == :default
    end
    
    it "should set tabs to []" do
      @tab_set.tabs.should == []
    end
    
    it "should return css class" do
      @tab_set.css_class.should == 'tab-set'
    end
    
    it "should return dom id" do
      @tab_set.dom_id.should == 'tab-set-default'
    end
    
    it "should return display_current_tab_as_text" do
      @tab_set.display_current_tab_as_text?.should be_nil
    end
    
    it "should return html" do
      html = @tab_set.html
      html.should == %(<ul class="tab-set" id="tab-set-default"></ul>)
    end
    
    it "should raise error on unknown option" do
      lambda { TabNav::TabSet.new(@template, :bad => :arg) }.should raise_error(ArgumentError)
    end
  end
  
  describe 'all options' do
    before(:each) do
      @tab_item = TabNav::Tab.new(:home, '/home')
      @tab_set = TabNav::TabSet.new(@template,
        :name => :main,
        :tabs => [@tab_item],
        :css_class => 'my-class',
        :dom_id => 'my-id',
        :display_current_tab_as_text => true
      )
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
  
    it "should set css class" do
      @tab_set.css_class.should == 'my-class'
    end
    
    it "should set dom id" do
      @tab_set.dom_id.should == 'my-id'
    end
    
    it "should return html" do
      @template.stub!(:current_tabs).and_return({})
      html = @tab_set.html
      open_tag = %(<ul class="my-class" id="my-id">)
      tab_html = @tab_item.html
      
      html.should == "#{open_tag}#{tab_html}</ul>"
    end
    
  end
  
  describe 'adding tabs' do
    before(:each) do
      @tab_set = TabNav::TabSet.new(@template)
      @tab_home = TabNav::Tab.new(:home, "/")
    end
    
    it "should add a TabNav::Tab" do
      @tab_set.add(@tab_home)
      @tab_set.tabs.should == [@tab_home]
    end
    
    it "add should work with params" do
      @tab_set.add(:about, "/about", :dom_id => 'dom_id')
      @tab = @tab_set.tabs.first
      @tab.should be_instance_of(TabNav::Tab)
      @tab.name.should == :about
      @tab.url.should == "/about"
      @tab.dom_id.should == 'dom_id'
    end
    
    it "should add in constructor" do
      @tab_set = TabNav::TabSet.new(@template, :tabs => [@tab_home])
      @tab_set.tabs.should == [@tab_home]
    end
    
    it "should add in block" do
      @tab_set = TabNav::TabSet.new(@template) do |ts|
        ts.add @tab_home
      end
      @tab_set.tabs.should == [@tab_home]
    end
  end
  
end
