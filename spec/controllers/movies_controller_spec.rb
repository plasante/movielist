require 'spec_helper'

describe MoviesController do
  render_views
  
  describe "DELETE :destroy" do
    describe "as a non administrator" do
      before(:each) do
        test_sign_in(Factory(:user))
        @movie = Factory(:movie)
      end
      
      it "should protect the action" do
        delete :destroy, :id => @movie
        response.should redirect_to(root_path)
      end
    end
    
    describe "as an administrator" do
      before(:each) do
        test_sign_in(Factory(:user, :administrator => true))
        @movie = Factory(:movie)
      end
      
      it "should destroy the movie" do
        lambda do
          delete :destroy, :id => @movie
        end.should change(Movie, :count).by(-1)
      end
    end
  end
end
