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
  
  describe "releases associations" do
    before(:each) do
      @movie = Factory(:movie)
      @rel1  = Factory(:release, :movie => @movie)
      @rel2  = Factory(:release, :movie => @movie)
    end
    
    it "should have a releases attribute" do
      @movie.should respond_to(:releases)
    end
    
    it "should have the releases in the right order" do
      @movie.releases.should == [@rel1,@rel2]
    end
    
    it "should destroy associated microposts" do
      @movie.destroy
      [@rel1,@rel2].each do |release|
        lambda do
          Release.find(release)
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
