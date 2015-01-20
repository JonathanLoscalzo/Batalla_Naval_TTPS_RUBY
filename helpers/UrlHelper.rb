module Sinatra
	module UrlHelper
		#Helpers
		module Helpers	
	      	def arg pos
  						params[:captures][pos]
	      	end
		end
		#end Helpers
		#App
		def self.registered(app)
	      	app.helpers UrlHelper::Helpers

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
	register UrlHelper #diferencia entre helper y register
end