class User < ActiveRecord::Base
  attr_accessor :password
  attr_accessible :first_name, :last_name, :username, :email, :password, :password_confirmation, :administrator, :lock_version
  
  validates :first_name, :presence     => true,
                         :length       => { :maximum => 50 }
  
  validates :last_name,  :presence     => true,
                         :length       => { :maximum => 50 }
  
  # The only way to make sure username is unique is to add an index on the username column
  # to the users table.
  validates :username,   :presence     => true,
                         :length       => { :within => 6..40 },
                         :uniqueness   => { :case_sensitive => false }
  
  validates :email,      :format       => { :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]{2,3}\z/i },
                         :uniqueness   => { :case_sensitive => false }
                         
  validates :password,   :presence     => true,
                         :confirmation => true,
                         :length       => { :within => 6..40 }
                        
  validate :max_number_users
  
  before_save :encrypt_password
                         
  def has_password?( submitted_password )
    encrypted_password == encrypt( submitted_password )
  end
  
  def self.authenticate( username, submitted_password)
    user = find_by_username( username )
    return nil if user.nil?
    return user if user.has_password?( submitted_password )
  end
  
  def self.authenticate_with_salt( user_id, cookie_salt )
    user = find_by_id( user_id )
    user && user.salt == cookie_salt ? user : nil
  end
  
private

  def encrypt_password
    self.salt = make_salt unless has_password?(password)
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt( string )
    secure_hash("#{salt}--#{string}")
  end
  
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def max_number_users
    if User.count >= USERS_MAX_COUNT
      raise "Maximum number of users reached"
    end
  end
end
