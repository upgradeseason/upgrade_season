class ApplicationController < ActionController::Base
  def welcome
    render html: "Welcome to the blogging and content sharing platform dedicated to upgrading our lives and mindset!"
  end
end
