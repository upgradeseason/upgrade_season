class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @micropost = current_user.microposts.build #We have associations, need this var in micropost partial
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

#Define ivar to put feed on homepage as mocked up
