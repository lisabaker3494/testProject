namespace :compile do
	desc "Initialize Compile Variables"
	task :init do
		version = SemVer.find
		FORMAL_VERSION = version.format("%M.%m.%p")
		ASSEMBLY_VERSION = "#{SemVer.new(version.major, version.minor, 0).format "%M.%m.%p"}"
	end	

	desc "Update assembly info files for each project in the solution"
	task :asminfo do
		puts FORMAL_VERSION
		puts ASSEMBLY_VERSION
		FileList["./*/Properties/"].each {|folder|
			(assemblyinfo folder do |asm|
				asm.version = "#{ENV['GO_PIPELINE_LABEL']}" 	
				asm.file_version = FORMAL_VERSION
				asm.company_name = configatron.asm_settings.company_name
				asm.product_name = configatron.asm_settings.product_name
				asm.title = configatron.asm_settings.title
				asm.description = configatron.asm_settings.description
				asm.copyright = configatron.asm_settings.copyright
				asm.trademark = configatron.asm_settings.trademark
				asm.language = configatron.asm_settings.language
				# asm.custom_attributes :SomeAttribute => "some val", :AnotherAttribute => "some data"
				asm.input_file = "#{folder}/AssemblyInfo.cs"
				asm.output_file = "#{folder}/AssemblyInfo.cs"
			end).invoke
		}
	end

	desc "Build solution in appropriate configuration mode"
	msbuild :build do |msb|
		msb = "C:/Windows/Microsoft.NET/Framework/v4.0.30319/msbuild.exe"
		msb.solution = "./testProject.sln"	
		msb.targets = [:Rebuild]
		msb.properties = {
			:configuration => ENV["build_configuration"] || :Debug,		
			:platform => "Any CPU",
			:pipelinedependsonbuild => false,		
			:outputpath => "_build/bin",
			:usewpp_copywebapplication => true,
			:webprojectoutputdir => "_build"
		}
		msb.verbosity = :minimal
		msb.nologo
	end	
	
	desc "Open the solution file"
	task :open_sln do
		Thread.new do
			system "devenv ./testProject.sln"
		end
	end

	desc "Copy only the wanted files and folders"
	output :output do |out|
		out.from './testProject/_build'
		out.to './testProject/_stage'
	
		#out.file 'Web.Debug.config', :as => 'Web.config'
		out.file 'web.config'
		out.file 'global.asax'		
		out.file 'favicon.ico'
	 
		['bin', 'views', 'content', 'fonts', 'scripts', 'img'].each do |d|
			out.dir d
		end
	end
	
	desc "Run all build tasks"
	task :all => [:init, :asminfo, :build, :output]
end