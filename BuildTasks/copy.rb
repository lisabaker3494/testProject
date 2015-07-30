require "fileutils"

namespace :copy do
	task :backup do
		#FileUtils.mv("path/to/prod/", "path/to/backup/")
	end
	
	task :deploy do
		#FileUtils.mv("./pkg/", "path/to/prod/")	
	end
	
	task :all => [:backup, :deploy]
end
#C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
#           MyWebApp/MyWebApp/MyWebApp.csproj
#           /T:Package
#           /P:Configuration=Debug;PackageLocation="C:\Build\MyWebApp.Debug.zip"

#C:\Program Files\IIS\Microsoft Web Deploy V2\msdeploy.exe" -verb:sync
#     -source:package="C:\Build\MyWebApp.Debug.zip"
#     -dest:auto,wmsvc=devserver,username=deployuser,password=*******
#     -allowUntrusted=true