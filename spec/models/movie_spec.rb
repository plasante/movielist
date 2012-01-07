require 'spec_helper'

describe Movie do
  before(:each) do
    @attr = {:title => 'Title', :rating => 'Rating'}
  end
  
  it "should require a title" do
    no_title_movie = Movie.new(@attr.merge(:title => ""))
    no_title_movie.should_not be_valid
  end
  
  it "should reject title too short" do
    short_title = ""
    short_title_movie = Movie.new(@attr.merge(:title => short_title))
    short_title_movie.should_not be_valid
  end
  
  it "should reject title too long" do
    long_title = "a" * 101
    long_title_movie = Movie.new(@attr.merge(:title => long_title))
    long_title_movie.should_not be_valid
  end
  
  it "should accept null rating value" do
    null_rating_movie = Movie.new(@attr.merge(:rating => nil))
    null_rating_movie.should be_valid
  end
end
