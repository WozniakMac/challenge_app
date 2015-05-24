class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  devise :database_authenticatable, :registerable, :validatable,
          :omniauthable, :omniauth_providers => [:github]

  has_attached_file :avatar, :styles => { :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  has_many :questions
  has_many :answers

  def to_s
    name.nil? or name == '' ? email : name
  end

  def add_points(num_points)
  	self.points = 0 if self.points.nil?
  	self.points = self.points + num_points
  	self.save
  end

  def remove_points(num_points)
  	self.points = 0 if self.points.nil?
  	self.points = self.points - num_points
  	self.save
  end

  def points_show
    self.points.nil? ? 0 : self.points
  end

  def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.provider = auth.provider
        user.uid = auth.uid
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.save
      end
  end
end
