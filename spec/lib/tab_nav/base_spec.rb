require File.dirname(__FILE__) + '/../../spec_helper'

describe TabNav::Base do
  before(:each) do
    @template = ActionView::Base.new
    @base = TabNav::Base.new(@template)
    end
     
end