class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :inactive_at, :first_name, :last_name, :display_name
  
  has_many :gathering_users
  has_many :event_users
  has_many :gatherings, :through => :gathering_users
  has_many :events, :through => :event_users
  
  validates :first_name, :presence => true;
  
  def is_active?
    inactive_at.nil? && persisted?
  end
  def is_admin?
    
  end
end
