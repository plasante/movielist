require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    movie = Factory(:movie)
    visit edit_movie_path(movie)
    # Here you have to know that the login page will be rendered for the user to sign in.
    fill_in :session_username, :with => user.username
    fill_in :session_password, :with => user.password
    click_button
    # If login was successful then the edit movie page will be rendered.
    response.should render_template('movies/edit')
  end
  
  it "should detect stale object" do
    
    # creating two users user1 and user2 ( in fact it simulates two parallel sessions )
    user1 = login(:user1)
    user2 = login(:user2)
    
    # user1 and user2 will try to update the same object
    movie = Factory(:movie)
    
    # signing in the user1 and user2
    user1.controller.should be_signed_in
    user2.controller.should be_signed_in
    
    # simulating user1 and user2 going to the movie edit page
    user1.visit edit_movie_path( movie )
    user2.visit edit_movie_path( movie )
    
    # user1 change the title of the movie and click button to update the database
    user1.fill_in :movie_title, :with => %(new title)
    user1.click_button
    
    # user2 try the same but got an error message saying somebody else had already changed the title
    user2.fill_in :movie_title, :with => %(another title)
    user2.click_button
    user2.flash[:error].should =~ /Movie was already changed/i
    
    # user2 second attempt to edit movie title using DSL
    user2.edit_movie( movie )
    user2.flash[:notice].should =~ /Movie was successfully updated./i
    
  end
  
private
  
  module CustomDsl
    def edit_movie( movie )
      visit edit_movie_path( movie )
      fill_in :movie_title, :with => %(new title)
      click_button
    end
  end
  
  def login(user)
    open_session do |session|
      session.extend(CustomDsl)
      u = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
      session.visit signin_path
      session.fill_in :session_username, :with => u.username
      session.fill_in :session_password, :with => u.password
      session.click_button
    end
  end
end
