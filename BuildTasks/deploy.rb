require "net/ftp"
require "yaml"

namespace :deploy do
	desc "Deploy website to environment"
	msdeploy :send do |dep|
		dep.server = ""
		dep.deploy_package = ""
		#dep.parameters_file
		#dep.server
		#dep.username
		#dep.password
		#dep.additional_parameters
		#dep.noop		
	end	
	
	task :backup do
		Dir.mkdir("tmp") unless Dir.exists?("tmp")
		Backup.run("./tmp", "/", "build")
		Deployer.run("./tmp", "/myTrueHarvest", "backup")
		Backup.clean("./tmp")
	end
	
	task :ftp do
		Deployer.run("./FLA.TrueHarvest.Web/_stage", "/", "build")	
	end
	
	task :all => [:backup, :ftp]
end
#C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
#           MyWebApp/MyWebApp/MyWebApp.csproj
#           /T:Package
#           /P:Configuration=Debug;PackageLocation="C:\Build\MyWebApp.Debug.zip"

#C:\Program Files\IIS\Microsoft Web Deploy V2\msdeploy.exe" -verb:sync
#     -source:package="C:\Build\MyWebApp.Debug.zip"
#     -dest:auto,wmsvc=devserver,username=deployuser,password=*******
#     -allowUntrusted=true