module TabNav #:nodoc:
  
  class Tab < Base
  
    attr_accessor :name, :url, :options, :tab_set
    
    def initialize(name, url, options = {})
      self.name = name
      self.url = url
      self.options = options
    end
    
    def css_class
      ['tab-item', options[:css_class]].flatten.compact.join(' ')
    end
    
    def dom_id
      options[:dom_id] || "tab-#{name}"
    end
    
    def label
      options[:label] || name.to_s.titleize
    end
    
    def current?
      tab_set.current_tab.to_s.downcase == name.to_s.downcase
    end
    
    # TODO: css class, dom id for <a>, <li>?
    def html
      raise("TabNav::Tab can't return html until attached to a TabNav::TabSet") unless tab_set.instance_of?(TabSet) 
        
      content = if current?
        content_tag(:span, label, :class => 'tab-item-current')
      else
        link = link_to(label, url)
      end
      
      content_tag(:li, content, :class => css_class, :id => dom_id)
    end
    
    def method_missing(*args, &block)
      tab_set.send(*args, &block)
    end
    
  end
  
end
