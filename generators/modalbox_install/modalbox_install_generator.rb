class ModalboxInstallGenerator < Rails::Generator::Base
	def manifest
    record do |m|
      # Copy over modalbox.js
			#
			m.file "javascripts/modalbox.js", "public/javascripts/modalbox.js"
      m.file "stylesheets/modalbox.css", "public/stylesheets/modalbox.css"
			m.directory "public/images/modalbox"
			m.file "images/modalbox/spinner.gif", "public/images/modalbox/spinner.gif"
    end
  end
end