class SessionsController < ApplicationController
  def show
    current_user = User.where(authentication_token: params[:authentication_token]).first
  	if current_user
  		render json: current_user.as_json(except: [:id, :password]), status: :acepted
  	else
  		head(:unauthorized)
  	end
  end

  def create
    user = User.where(email: params[:email]).first
    if user&.valid_password?(params[:password])
    	render json: user.as_json(only: [:email, :authentication_token]), status: :created
    else
    	head(:unauthorized)
    end
  end
  def destroy
    current_user = User.where(authentication_token: params[:authentication_token]).first
  	current_user&.authentication_token = nil
  	if current_user.save
  		head(:ok)
  	else
  		head(:unauthorized)
  	end
  end

end