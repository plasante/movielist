require 'spec_helper'

describe "LayoutLinks" do
  it "should have a home page at '/'" do
    get '/'
    response.should have_selector('title', :content => %(Movies))
  end
end
