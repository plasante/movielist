require 'spec_helper'

describe Release do

  before(:each) do
    @attr = {
      :format => "dvd",
      :released_on => Time.now.utc
    }
  end
  
  it "should create a release given right attributes" do
    Release.create!(@attr)
  end
  
  it "should require a released_on attribute" do
    no_released_on_release = Release.new(@attr.merge(:released_on => ""))
    no_released_on_release.should_not be_valid
  end
  
  it "should require a format attribute" do
    no_format_release = Release.new(@attr.merge(:format => ""))
    no_format_release.should_not be_valid
  end
end
