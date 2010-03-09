module TabNav
  
  class TabSet < Base
  
    attr_accessor :template, :name, :tabs, :options
    
    def initialize(template, name, tabs = [], options = {})
      raise(ArgumentError, "Expected ActionView::Base, got #{template.class}") unless template.is_a?(ActionView::Base)
      self.template = template
      self.name = name
      self.tabs = tabs
      self.options = options
    end
    
    def css_class
      ['tab-set', options[:css_class]].flatten.compact.join(' ')
    end
    
    def dom_id
      options[:dom_id] || "tab-set-#{name}"
    end
    
    def html
      content = tabs.
          each { |tab| tab.tab_set = self }.
          map(&:html).
          join("\n")
      content_tag(:ul, content, :class => css_class, :id => dom_id) +
       "#{current_tabs.inspect}"
    end

    def current_tab
      current_tabs[name] || current_tabs[:default]
    end
    
    def method_missing(*args, &block)
      template.send(*args, &block)
    end
    
  end
  
end