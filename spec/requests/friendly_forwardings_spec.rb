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
end
