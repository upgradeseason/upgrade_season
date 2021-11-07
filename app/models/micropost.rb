class Micropost < ApplicationRecord
  belongs_to       :user
  has_one_attached :image
  #^This prepares our model, now in the mp form view, need place to upload image
  #Then need place in mp controller=>create action to attach image to mp just built
  #Single image per mp, vs #has_many_attached
  #default_scope -> set the default order in which elements are retrieved from the database
  #When we define a scope, we need to put inside the block, after the arrow, method that specifies behavior of scope
  #Raw SQL keyword in all caps => DESC
  #default_scope -> { order('created_at DESC') }
  #Can replace raw SQL with pure Ruby, key value pair
  default_scope -> { order(created_at: :desc) }
  #Add some validations to enforce the desired design constraints
  validates :user_id, presence: true #Should be using Active Record associations here
  validates :content, presence: true, length: { maximum: 160 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes,
                                      message:   "should be less than 5MB" }
  #validates :image,   content_type: ['image/jpeg', 'image/png'],
  #                    size:         { less_than: 2.megabytes }

  # Returns a resized image for display
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

  #def display_image
  #  image.resize "500x500"
 # end
end
