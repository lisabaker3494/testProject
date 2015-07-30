begin
	require "rake"
	require "configatron"
	require "albacore"	
	require "semver"
rescue LoadError
	puts "rake, configatron, albacore and semver must be installed prior to running this script"
	#system("gem install rake")
	system("gem install configatron")
	system("gem install albacore")
	system("gem install semver2")

	exit 0
end

#Verbose level tracing for debugging
#Comment out block for live builds
Albacore.configure do |config|
    config.log_level = :verbose    
end

# load BuildClasses
FileList["../BuildClasses/*.rb"].each do |file|
	require file
end

# load Configuration files
FileList["./BuildConfigurations/*.rb"].each do |file|
	load file
end

# load BuildTasks
FileList["./BuildTasks/*.rb"].each do |file|
	require file
end

desc "Entry point to run tasks"
task :default => ["versioning:all", "init:all", "compile:all", "testing:all", "coverage:all"]

namespace :init do
	desc "Setup build environment"
	task :prepare do
		version = SemVer.find		
		#Rake::Task["versioning:increment_version_patch"].invoke(ENV["GO_PIPELINE_COUNTER"])
		Rake::Task["versioning:increment_version_metadata"].invoke("#{ENV['GO_PIPELINE_COUNTER']}_#{ENV['GO_REVISION']}")
		FORMAL_VERSION = SemVer.find.format("%M.%m.%p")
	
		Dir.mkdir("#{configatron.app_settings.output_dir}") unless Dir.exists?("#{configatron.app_settings.output_dir}")				
		Dir.mkdir("#{configatron.app_settings.archive_dir}") unless Dir.exists?("#{configatron.app_settings.archive_dir}")	
	end#	
	desc "Run all set-up tasks"
	task :all => ["versioning:init", :prepare]	
end