module Sinatra
	module BoardHelper
		#Helpers
		module Helpers
		end
		#end Helpers
		#App
		def self.registered(app)
	      	app.helpers BoardHelper::Helpers
	    end
	    #end App
	end
	#End sessionHelper
	register BoardHelper #diferencia entre helper y register
end