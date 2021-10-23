class User < ApplicationRecord
  #Add accessible attributes, since it's not saving to the DB.
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }#true

   #Adds .authenticated? method, returns false for invalid authorization. This way, we get password attribute
  #Automatically creates virtual attributes (meaning it doesn't exist in the DB) called password and pw confirmation
  has_secure_password
  validates :password, presence: true, length: { minimum: 5 }, allow_nil: true

  #For the test db password. It returns the hash digest of a given string.
  #def User.digest(string)
  #def digest(string)
  def self.digest(string) #Idiomatically correct
  #class << self #invalid syntax?
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  #Returns a random token
  def User.new_token
  #def self.new_token #Idiomatically correct
  #def new_token #invalid syntax?
    SecureRandom.urlsafe_base64
  end

  #Add a remember method to the user model
  #Remembers a user in the db for persistent sessions
  #Associate remember token with user and save it(corresponding user digest) to DB
  def remember
    #self.remember_token = User.new_token #Need the self. otherwise creates a local var due to how Ruby handles assignment
    self.remember_token = User.new_token
    #Using self ensures remember_token attribute assigned to user.
    update_attribute(:remember_digest, User.digest(remember_token))
    #Use update_attribute method to update the remember digest
    #self. unnecessary inside user model
    #We have remember_DIGEST attribute in our db column bc of the migration but we dont have remember_TOKEN column yet
    #Calling user.remember gives user remember token in memory, and also create a remember digest that persists until we change it, logout sets to nil
  end

  def forget
    #Note the remember_digest attribute (it goes to the db).
    update_attribute(:remember_digest, nil)
  end

  #Returns true if the given token matches the digest
  #remember_token is a variable that's local to its method, not same as attr_accessor
  def authenticated?(remember_token)
    #Note explicitness of writing return, it says "Don't do anything else". It's same as writing an if/else/end stmt
     return false if remember_digest.nil?
     BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
