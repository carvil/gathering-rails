class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :token_authenticatable, :confirmable, :lockable, :token_authenticatable
  
    # Setup accessible (or protected) attributes for your model
    #attr_accessible :email, :display_name, :last_name, :first_name, :remember_me, :inactive_at, :password, :password_confirmation, :confirmed_at
    attr_accessible :first_name, :last_name, :display_name, :email, :password, :password_confirmation, :confirmed_at
    
    validates :display_name, :presence => true
    validates :first_name, :presence => true
    
    def is_active?
      inactive_at.nil?
    end
    
    def after_token_authentication
      reset_authentication_token!
    end
  end
end
