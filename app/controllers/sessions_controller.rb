require 'net/ldap'

class SessionsController < ApplicationController
  soap_service namespace: 'urn:WashOutSessions'

  soap_action "showSession",
                :args   => { :token => :string },
                :return => {  :id => :integer,
                              :name => :string,
                              :nickname => :string,
                              :email => :string,
                              :wallet_id => :integer,
                              :autentication => :boolean
                            }

  def showSession
    current_user = User.where(authentication_token: params[:token]).first

  	if current_user
  		render :soap => { :id => current_user.id, :name => current_user.name, :nickname => current_user.nickname,
                        :email => current_user.email, :wallet_id => current_user.wallet_id, :autentication => true
                      }
  	else
  		render :soap => { :id => 0, :name => "none", :nickname => "none", :email => "none", :wallet_id => 0, :autentication => false }
  	end
  end

  soap_action "createSession",
                :args   => { :email => :string, :password => :string },
                :return => {  :email => :string,
                              :authentication_token => :string,
                              :autentication => :boolean
                           }

  def createSession
    email = params[:email].downcase
    password = params[:password]

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
          return render :soap => { :email => user.email, :authentication_token => user.authentication_token, :autentication => true }
        end

      end
    end

    render :soap => { :email => "none", :authentication_token => "none", :autentication => false }
  end

  soap_action "destroySession",
                :args   => { :token => :string },
                :return => { :id => :integer, :autentication => :boolean }

  def destroySession
    current_user = User.where(authentication_token: params[:token]).first
  	current_user&.authentication_token = nil
  	if current_user
      current_user.save
  		render :soap => { :id => current_user.id, :autentication => true }
  	else
  		render :soap => { :id => -1, :autentication => false }
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
