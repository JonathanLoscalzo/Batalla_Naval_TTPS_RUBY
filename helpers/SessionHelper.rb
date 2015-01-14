module Sinatra
	module SessionHelper
		#Helpers
		module Helpers	
			def authorized?
	        	session[:authorized]
	      	end

	      	def authorize!
	      		#se usa cuando no tiene permiso. En un before
	        	redirect '/login' unless authorized?
	      	end

	      	def logout!
	        	session[:authorized] = false
	        	session[:user_id] = nil
				session[:username] = nil
	      	end

	      	def login(username:, password:)
	      		user = User.where(username:username.to_s, password:password.to_s).first
				if user
					session[:user_id] = user.id
					session[:username] = user.username
					session[:authorized] = true
				else
					p 'no hay nadie'
				end
			end

			def actual_user
				session[:username]
			end

			def actual_user_id
				session[:user_id]
			end
		end
		#end Helpers
		#App
		def self.registered(app)
	      	app.helpers SessionHelper::Helpers

	      	app.configure do
	      		app.enable :session
	      	end

			app.set(:auth) do
				#se agrega a los metodos que quiero que sea necesario autenticarse
				condition do 
					unless authorized?
						authorize!
					end
				end
			end
	    end
	    #end App
	end
	#End sessionHelper
	register SessionHelper #diferencia entre helper y register
end