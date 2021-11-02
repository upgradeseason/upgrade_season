class User < ApplicationRecord
  # We passed an option to the has_many association method:
  # It arranges for the dependent microposts to be destroyed when the user itself is destroyed.
  # Rails looks for Micropost class, because there's a micropost model.
  has_many :microposts, dependent: :destroy
  # Need to tell Rails the class, as an argument here, since there's no model.
  has_many :active_relationships, class_name:   "Relationship",
                                  foreign_key:  "follower_id",
                                  dependent:    :destroy #This destroyed if user destroyed
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key:  "followed_id",
                                  dependent:    :destroy #This destroyed if user destroyed
  has_many :following, through: :active_relationships,  source: :followed
  # Parallel structure
  has_many :followers, through: :passive_relationships, source: :follower

  # We add accessible attributes, because it's not saving to the DB.
  attr_accessor :remember_token, :activation_token, :reset_token

  # We use a before_save callback.
  before_save :downcase_email #A method reference is used instead of { self.email = email.downcase }.
  # This is an ActiveRecord callback with a method reference.
  before_create :create_activation_digest

  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  # Adds #authenticated? method, returns false for invalid authorization. This way, we get the password attribute.
  # Automatically creates virtual attributes (meaning it doesn't exist in the DB) of password and password confirmation.
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

  # For the test db password. It returns the hash digest of a given string.
  # def User.digest(string) #Alternate implementations
  # def digest(string)
  def self.digest(string) #Idiomatically correct
  # class << self
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token
  def User.new_token
  # def self.new_token #Idiomatically correct
  # def new_token #invalid syntax?
  # Self is optional in the model
    SecureRandom.urlsafe_base64
  end

  # Add a remember method to the user model
  # Remembers a user in the db for persistent sessions
  # Associate remember token with user and save it(corresponding user digest) to DB
  def remember
    # self.remember_token = User.new_token #Need the self. otherwise creates a local var due to how Ruby handles assignment
    self.remember_token = User.new_token
    # Using self ensures remember_token attribute assigned to user.
    update_attribute(:remember_digest, User.digest(remember_token))
    # Use update_attribute method to update the remember digest
    # self. unnecessary inside user model
    # We have remember_DIGEST attribute in our db column bc of the migration but we dont have remember_TOKEN column yet
    # Calling user.remember gives user remember token in memory, and also create a remember digest that persists until we change it, logout sets to nil
  end

  def forget
    # Note the remember_digest attribute (it goes to the db).
    update_attribute(:remember_digest, nil)
  end

  # Returns true if the given token matches the digest
  # remember_token is a variable that's local to its method, not same as attr_accessor
  # def authenticated?(remember_token)
    # Note explicitness of writing return, it says "Don't do anything else". It's same as writing an if/else/end stmt
    # return false if remember_digest.nil?
    # BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  def authenticated?(attribute, token)
    # Instead of tying this to the remember_digest we can do this >
    digest = send("#{attribute}_digest")
    # This method authenticates a different token against a different digest based on the value of this attribute.
    return false if digest.nil?
    # New password called on digest
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account
  def activate
    # user.update_attribute(:activated,    true)
    # self.update_attribute(:activated_at, Time.zone.now)
    # Calls DB twice
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
    self.update_columns(activated: true, activated_at: Time.zone.now)
    # ^Made this one line by knowing the method and checking the standard lib documentation
  end

  # Refactor a little by moving some of the user manipulation out of the controller and into the model
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes
  def create_reset_digest
    self.reset_token = User.new_token
    # One DB operation > it hits the DB only once
    self.update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired
  def password_reset_expired?
    # The way to do this is to compare whether the reset_sent_at timestamp was sent 'earlier than' 2.hours.ago
    reset_sent_at < 2.hours.ago
  end

  # Defines a proto-feed
  # See "Following users" for the full implementation.
  # Returns a user's status feed

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
              OR user_id = :user_id", user_id: id) 
    # ^self.following_ids, self.user_id)
    # self.microposts is equiv inside this user model
    # Useful function for issuing SQL queries
    # ? escapes out anything inserted, avoids SQL injection, never b vulnerable
  end

  # Follows a user. Creates that relationship. This is a working backend now, for user following and unfollowing.
  def follow(other_user)
    following << other_user unless self == other_user
    # Shovel operator, same as push method, we go through the association and use these array methods.
  end

  #Destroys the follow relationship.
  def unfollows(other_user)
    following.delete(other_user) #Not technically an array but can treat it like that thanks to Ruby on Rails.
  end

  # Boolean following test returns true if the current user is following the other user.
  def following?(other_user)
    # This is the collection of users the user is following, see if other user in that list, treat like an array.
    # self.following.include?(other_user)
    # Remove self wherever possible
    following.include?(other_user)
    # Find the relationship, see if it exists
    # !active_relationships.find_by(followed_id: other_user.id).nil?
  end

  private

  # Converts email to all lower-case
  def downcase_email
    #self.email = email.downcase
    email.downcase!
  end

  #Creates and assigns the activation token and digest. Only used internally by the user model, no need to expose it to outside users.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
