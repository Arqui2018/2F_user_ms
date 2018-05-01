class SessionsController < ApplicationController

  def show
    current_user = User.where(authentication_token: params[:authentication_token]).first
  	if current_user
  		render json: current_user.as_json(except: [:password]), status: :accepted
  	else
  		head(:unauthorized)
  	end
  end

  def create
    email = params[:email]
    password = params[:password]
    email = email[/\A\w+/].downcase
    if connect
      ldap = Net::LDAP.new(
        host: 'bet-ldap',
        port: 389,
        auth: {
          method: :simple,
          dn: 'cn=' + email + ', ou=worldwide,dc=arqsoft,dc=bet,dc=com,dc=co',
          password: password
        }
      )
      if ldap.bind # autentication with ldap

        user = User.where(email: email).first
        if user&.valid_password?(password)
        	render json: user.as_json(only: [:email, :authentication_token]), status: :created
        else
        	head(:unauthorized)
        end
      else
        head(:unauthorized)
      end

    end
  end

  def destroy
    current_user = User.where(authentication_token: params[:authentication_token]).first
  	current_user&.authentication_token = nil
  	if current_user.save
  		render json: current_user.as_json(only: [:id]), status: :ok
  	else
  		head(:unauthorized)
  	end
  end

  private
    def connect
      ldap = Net::LDAP.new(
        host: 'academy-ldap',
        port: 389,
        auth: {
          method: :simple,
          dn: 'cn=admin,dc=arqsoft,dc=bet,dc=com,dc=co',
          password: 'admin'
        }
      )
      ldap.bind
    end

end
