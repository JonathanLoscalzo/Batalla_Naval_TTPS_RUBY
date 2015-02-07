module Sinatra
	module SessionHelper
		#Helpers
		module Helpers	
			def authorized?
	        	session[:authorized]
	      	end

	      	def authorize!
	      		#se usa cuando no tiene permiso.
	        	unless authorized?
	        		session[:message] = { :value => "No tiene permiso para estar aquí.", :type => "danger" }
	        		status 304
	        		redirect '/login'
	        	end
	      	end

	      	def logout!
	      		if session[:authorized]
	        		session[:message] = { :value => "Adiós!", :type => "success" }
	        		status 201
	      		else
	        		session[:message] = { :value => "No puede cerrar sesión, si no ha iniciado", :type => "info" }
	        		status 401
	      		end
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
					true
				else
					session[:authorized] = false
					session[:message] = { :value => "El Usuario "+ username +" No existe.", :type => "danger" }
					false
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

			app.set(:auth) do
				#se agrega a los metodos que quiero que sea necesario autenticarse
				condition do 
					authorize!
				end
			end
	    end
	    #end App
	end
	#End sessionHelper
	register SessionHelper #diferencia entre helper y register
end