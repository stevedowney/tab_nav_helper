module TabNav #:nodoc:

  module ControllerMethods #:nodoc:

    module ClassMethods
      
      # call-seq: 
      #   current_tab(tab_name, options = {})
      #   current_tab(tab_set_name, tab_name, options = {})
      #
      # Set current tab at the controller level.
      #
      # The first call sequence is used when you only have one tab set on your page.
      # If you have multiple tab sets then you need to set the current tab for each one.
      #
      # Supported options are the same as the options for controller filters:
      #
      # * :only
      # * :except
      # * :if
      # * :unless
      #
      # == Examples
      #
      # To set the tab for all actions in a controller for a single tab set:
      #
      #   class HomeController < ActionController::Base
      #     current_tab :home
      #   end
      #
      # If there is more than one tab set on a page you must specifiy the tab set name:
      #
      #   class HomeController < ActionController::Base
      #     current_tab :major_tabs, :home
      #   end
      #
      def current_tab(*args)
        options = args.extract_options!

        before_filter(options) do |controller|
          controller.send(:current_tab, *args)
        end
      end

    end

    module InstanceMethods

      # call-seq: 
      #   current_tab(tab_name)
      #   current_tab(tab_set_name, tab_name)
      #
      # Set current tab at the action level.
      #
      # The first call sequence is used when you only have one tab set on your page.
      # If you have multiple tab sets then you need to set the current tab for each one.
      #
      #   class HomeController < ActionController::Base
      #
      #     def index
      #       current_tab :home
      #     end
      #
      #   end
      def current_tab(*args)
        if args.length == 1
          tab_set_name = :default
          tab_name = args[0]
        else
          tab_set_name = args[0]
          tab_name = args[1]
        end
        current_tabs[tab_set_name] = tab_name
      end

      # Returns a hash of current tabs whose keys are tab set names and values
      # are tab names.
      #
      #   current_tabs              #=> {}
      #   current_tab(:foo)
      #   current_tabs              #=> {:default => :foo}
      #   current_tab(:main, :bar)
      #   current_tabs              #=> {:default => :foo, :main_nav => :bar}
      #   
      # This is available as a +helper_method+ in views and helpers.
      def current_tabs
        @current_tabs ||= {}
      end

    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
      receiver.send :helper_method, :current_tabs
    end

  end

end


