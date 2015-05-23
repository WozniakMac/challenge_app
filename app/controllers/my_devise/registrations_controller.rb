class MyDevise::RegistrationsController < Devise::RegistrationsController
  def create
    super
    resource.points = 100
    resource.save
  end
end