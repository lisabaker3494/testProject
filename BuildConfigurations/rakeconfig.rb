#build environment
build_solution_name = "testProject"
build_configuration = ENV["build_configuration"] || "debug"
build_environment = if("#{build_configuration}" == "debug") then "CI" else "#{build_configuration}" end

#directories
build_tools_dir = "C:/buildtools"
testing_tools_dir = "C:/testingtools"

#properties settings from yml
#configatron.configure_from_yaml 'properties.yml', :hash => build_configuration

#general settings
configatron.app_settings do |app_settings|
	app_settings.build_solution_name = "#{build_solution_name}"
	app_settings.base_dir = File.dirname(__FILE__)
	app_settings.deploy_dir = "c:/webroot/#{build_environment}"
	app_settings.output_dir = "./BuildOutputs"
	app_settings.document_dir = "./BuildDocuments"
	app_settings.archive_dir = "./BuildArchives"
end

#assembly info settings
configatron.asm_settings do |asm_settings|
	asm_settings.title = "testProject"
	asm_settings.description = "testProject"
	asm_settings.company_name = "FarmLink, LLC"
	asm_settings.product_name = "MFR Manager"
	asm_settings.copyright = "\u00A9 #{DateTime.now.year.to_s} FarmLink, LLC"
	asm_settings.trademark = ""
	asm_settings.language = "C#"
end

#nuget settings
configatron.nuget_settings do |nuget_settings|
	nuget_settings.nuget_exe = "#{build_tools_dir}/NuGet/NuGet.exe"
	nuget_settings.nuget_api_key = ""
	nuget_settings.nuget_source = ""
	nuget_settings.nuspecs_dir = "./nuspecs"
	nuget_settings.nupkgs_dir = "./nupkgs"
end

#build settings
configatron.build_settings do |build_settings|
	build_settings.docu_exe = "#{build_tools_dir}/Docu/Docu.exe"	
end

#test settings
configatron.testing_settings do |testing_settings|
	testing_settings.xunit_exe = "#{testing_tools_dir}/xUnit/xunit.console.clr4.exe"
	testing_settings.specflow_exe = "#{testing_tools_dir}/SpecFlow/tools/specflow.exe"
	testing_settings.opencover_exe = "#{testing_tools_dir}/OpenCover/OpenCover.Console.exe"
	testing_settings.reportgenerator_exe = "#{testing_tools_dir}/ReportGenerator/bin/ReportGenerator.exe"
end