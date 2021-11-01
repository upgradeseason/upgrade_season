class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    #debugger
    #What is involved in creating this relationship? We need to pull out user.
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    #Ajax implementation
    respond_to do |format|
      format.html { redirect_to @user }
      format.js #Unobtrusive javascript
    #redirect_to user
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    #relationship.destroy
    current_user.unfollows(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    #redirect_to user
    end
  end
end
