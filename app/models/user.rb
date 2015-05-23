class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :recoverable, :rememberable and :trackable
  devise :database_authenticatable, :registerable, :validatable

  has_many :questions
  has_many :answers

  def to_s
    email
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
end
