module TabNav #:nodoc:
  # Class for modeling a set of navigation tabs.
  #
  # To simplify the API documentation most methods have had RDOC
  # suppressed.  Have a look at the source if you need finer-grained control
  # over TabSet instances.
  class TabSet < Base
    # call-seq: 
    #   new(template, options = {}, &block)
    #
    # Returns new instance of TabSet.
    #
    # === Examples
    #
    # Create TabSet instance -- need to add Tab's later with #add()
    #
    #   # in a view helper
    #   # must pass in instance of ActionView::Base, i.e. "self" in view or helper
    #
    #   tab_nav = TabNav::TabSet.new(self)
    #
    # Attach Tab's in contructor:
    #
    #   tabs = [
    #     TabNav::Tab.new(:home, "/home"),
    #     TabNav::Tab.new(:about, "/about")
    #   ]
    #   tab_nav = TabNav::TabSet.new(self, :tabs => tabs)
    #
    # Or using block:
    #
    #   tab_nav = TabNav::TabSet.new(self, :tabs => tabs) do |ts|
    #     ts.add TabNav::Tab.new(:home, "/home")
    #     ts.add :about, "/about"
    #   end
    #
    # === Options
    # * :name - defaults to <tt>:default</tt>
    # * :tabs - an Array of Tabs
    # * :css_class - "class" attribute on <ul> tag; defaults to "tab-set" -- anything
    #   you pass will be _added_ to the default class
    # * :dom_id - "id" attribute on <ul> tag; defaults to "tab-set-<name>"
    def initialize(template, options = {}, &block)
      raise(ArgumentError, "Expected ActionView::Base, got #{template.class}") unless template.is_a?(ActionView::Base)
      @template = template
      @name = options.delete(:name) || :default
      @options = options
      tabs = options.delete(:tabs) || []
      tabs.each { |tab| add(tab) }
      yield self if block_given?
    end
    
    def template #:nodoc:
      @template
    end
    
    def name #:nodoc:
      @name
    end

    def options #:nodoc:
      @options
    end
    
    # call-seq: 
    #   add(tab)
    #   add(tab_name, tab_url, tab_options => {})
    #
    # The first calling sequence is used when you are adding instances of TavNav::Tab:
    #
    #   tab = TabNav::Tab(:home, "/home")
    #   tab_set.add tab
    #
    # The second calling sequence is used to let the tab set implicitly create TabNav::Tab's
    # as a side-affect.  The arguments are the same as for TabNav::Tab.new:
    #
    #   tab_set.add :home, "/home", :label => "Home Page"
    #
    def add(*args)
      if args.length == 1
        tab = args[0]
      else
        tab = Tab.new(*args)
      end
      tab.tab_set = self
      tabs << tab
    end
    
    def tabs #:nodoc:
      @tabs ||= []
    end
    
    def css_class #:nodoc:
      ['tab-set', options[:css_class]].flatten.compact.join(' ')
    end
    
    def dom_id #:nodoc:
      options[:dom_id] || "tab-set-#{name}"
    end
    
    # Returns the html for this tab set as an unordered list; example assumes 
    # current tab is set to <tt>:home</tt>:
    #
    #   <ul class="tab-set" id="tab-set-default">
    #     <li class="tab-item-current" id="tab-home" title="You are at: /home"><span>Home</span></li>
    #     <li id="tab-project" title="Go to: /projects"><a href="/projects">Project</a></li>
    #     <li id="tab-about" title="Go to: /about"><a href="/about">About</a></li>
    #   </ul>
    def html
      content = tabs.map(&:html).join("\n")
      content_tag(:ul, content, :class => css_class, :id => dom_id)
    end

    def current_tab #:nodoc:
      current_tabs[name] || current_tabs[:default]
    end
    
    def method_missing(*args, &block) #:nodoc:
      template.send(*args, &block)
    end
    
  end
  
end