class User < ApplicationRecord
  attr_accessor :remember_token #Add accessible attributes since not saving to db
  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }#true

  has_secure_password #Adds #authenticate method (returns false for invalid auth), this is way we got pw attribute
  #^Automatically creates virtual(dont exist in db) attributes called pw and pw confirmation
  validates :password, presence: true, length: { minimum: 5 }

  #Returns hash digest of given string
  #For test db password
  #def User.digest(string)
  def self.digest(string) #Idiomatically correct
  #class << self #invalid syntax
  #def digest(string)
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
    update_attribute(:remember_digest, nil)
    #Note the remember_digest attribute(to db)
  end

  #Returns true if the given token matches the digest
  def authenticated?(remember_token) #remember_token is variable local to its method, not same as attr_accessor
    return false if remember_digest.nil? #Note explicitness of writing return dont do anything else vs if/else/end
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
