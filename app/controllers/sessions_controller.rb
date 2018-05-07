require 'net/ldap'

class SessionsController < ApplicationController
  soap_service namespace: 'urn:WashOutSessions', camelize_wsdl: :lower

  soap_action "showSession",
                :args   => { :authenticationToken => :string },
                :return => { :name => :string, :nickname => :string, :email => :string, :wallet_id => :integer, :autentication => :boolean }

  def showSession

    user = User.where(authentication_token: params[:authenticationToken]).first
  	if user
  		render :soap => { :name => user.name, :nickname => user.nickname, :email => user.email, :wallet_id => user.wallet_id, :autentication => true }
  	else
  		render :soap => { :name => "none", :nickname => "none", :email => "none", :wallet_id => 0, :autentication => false }
  	end
  end

  soap_action "createSession",
                :args   => { :email => :string, :password => :string },
                :return => { :email => :string, :authentication_token => :string, :autentication => :boolean }

  def createSession
    email = params[:email].downcase
    password = params[:password]

    # if connect
    #   ldap = Net::LDAP.new(
    #           host: 'bet-ldap',
    #           port: 389,
    #           auth: {
    #             method: :simple,
    #             dn: 'cn=' + email + ', ou=worldwide,dc=arqsoft,dc=bet,dc=com,dc=co',
    #             password: password
    #           }
    #         )
    #   if ldap.bind # autentication with ldap

        user = User.where(email: email).first
        if user&.valid_password?(password)
          return render :soap => { :email => user.email, :authentication_token => user.authentication_token, :autentication => true }
        end

    #   end
    # end

    render :soap => { :email => "none", :authentication_token => "none", :autentication => false }
  end

  soap_action "destroySession",
                :args   => { :authenticationToken => :string },
                :return => { :id => :integer, :removedSession => :boolean }

  def destroySession
    current_user = User.where(authentication_token: params[:authenticationToken]).first
  	current_user&.authentication_token = nil
  	if current_user.save
  		render :soap => { :id => current_user.id, :removedSession => true }
  	else
  		render :soap => { :id => 0, :removedSession => false }
  	end
  end

  private
    def connect
      ldap = Net::LDAP.new(
              host: 'bet-ldap',
              port: 389,
              auth: {
                method: :simple,
                dn: 'cn=admin,dc=arqsoft,dc=bet,dc=com,dc=co',
                password: 'admin'
              }
            )
      return ldap.bind
    end

end
