#namespace :iis do
#	desc "Updates the IIS site path to /webroot/[env]/[webproject]/[version]"
#	iispath :update do |iis|
#		version =  ENV["version"] || "Current V"
#		iis.command = "appcmd"
#		iis.site = "mysite.localhost.com"
#		iis.physical_path = File.expand_path("Path/of/deployment").gsub("/", "\\")
#	end
#end