class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create #This is our best guess at the backend, frontend is at home.html.erb
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    #Explicit call to #attach method
    #We need to add(attach) image to the newly created micropost object, use #attach
    #attach from activestorage API, we want to say params of mp, and then image
    if @micropost.save
      flash[:success] = "Mini-Post created!"
      redirect_to root_url
    else
     @feed_items = current_user.feed.paginate(page: params[:page])
     render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Mini-post deleted"
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  private #Private is only used internally, here by the microposts_controller, and not exposed to external users via web

    def micropost_params
    #Strong parameters => require and permit
    #Prevents attacker using curl to send patch request to make /users/17?admin=1
    #Write test to make sure admin attribute is not permitted attribute
    #It’s a good idea to write a test for any attribute that isn’t editable
    #List of attributes permitted to be modified through the web
    params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
