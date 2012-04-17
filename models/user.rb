# encoding: utf-8
require 'openssl'
require 'bcrypt'

class User < Sequel::Model(:users)
  #attr_accessor :username, :email, :password
  #is called after Base.save on new objects that haven‘t been saved yet (no record exists).
  def before_create
        #self.salt = OpenSSL::HMAC.hexdigest("--#{Time.now.to_f}--#{self.email}--")
        super
        self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_f}--#{self.email}--")
        self.password = encrypt(self.password,self.salt)
        self.created_at ||= Time.now
        self.updated_at ||= Time.now
  end

  #Is called after Base.save (regardless of whether it‘s a create or update save).
  def before_save
      super
      self.updated_at ||= Time.now
  end

  def encrypt(password,salt)
   BCrypt::Password.create("--#{password}--#{salt}--", :cost => 3) 
  end

  def decrypt(password,salt)
   BCrypt::Password.new(self.password) 
  end

  def self.authenticate(hash)
    username = hash[:username]
    password = hash[:password]

    if user = User[:username => username]
      user if user.authenticated?(password)
    end
  end
  
  def authenticated?(pass)
    self.password == decrypt(pass, self.salt)
  end
end
