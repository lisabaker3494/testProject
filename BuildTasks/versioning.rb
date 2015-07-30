# Major				Breaking changes
# Minor				Backwards compatible API changes
# Patch				Bugfixes not affecting the API
# PreRelease Tag	Alpha, Beta, ..., RC1, RC2, ...
# Build				Build Stamp, metadata, ...
namespace :versioning do
	desc "create version file"
	task :init do
		if !File.exists?("./.semver")
			sh "semver init"
			
			version = SemVer.find			
			version.minor += 1
			version.save
		end
	end

	desc "increment the major version number"
	task :increment_version_major do
		Rake::Task["versioning:increment_version"].invoke("major")
	end
	
	desc "increment the minor version number"
	task :increment_version_minor do
		Rake::Task["versioning:increment_version"].invoke("minor")
	end
	
	desc "increment the patch version number"
	task :increment_version_patch do
		Rake::Task["versioning:increment_version"].invoke("patch")
	end	
	
	desc "add build label alpha|beta|rc1|rc2..."
	task :increment_version_special, :increment_value do |t, args|
		Rake::Task["versioning:increment_version"].invoke("special", args[:increment_value])
	end
	
	desc "add meta data like CCNetLabel or SCM Build Label and the build number"	
	task :increment_version_metadata, :increment_value do |t, args|
		Rake::Task["versioning:increment_version"].invoke("metadata", args[:increment_value])
	end
	
	desc "increment the version number"
	task :increment_version, [:increment_type, :increment_value] => [:init] do |t, args|
		args.with_defaults(:increment_type => ENV["increment_type"] || "patch", :increment_value => ENV["increment_value"] || "")
		
		inc = args[:increment_type].downcase
		
		version = SemVer.find
		
		if inc == "major"
			version.major += 1
		elsif inc == "minor"
			version.minor += 1
		elsif inc == "patch"
			version.patch += 1
		elsif inc == "special"
			version.special = args[:increment_value]
		elsif inc == "metadata"
			version.metadata = args[:increment_value]			
		end
		
		version.save		
	end
	
	desc "get current version number"
	task :current_version => :init do
		version = SemVer.find
		
		# extensible number w/ Build Stamp from svn, git or ccnet
		ENV["BUILD_VERSION"] = BUILD_VERSION = version.format("%M.%m.%p%s") + ".#{version.metadata}"
		
		# major/minor - for strong name compatibility
		ENV["ASSEMBLY_VERSION"] = ASSEMBLY_VERSION = "#{SemVer.new(version.major, version.minor, 0).format "%M.%m.%p"}"
		
		# M.m.p format
		ENV["FORMAL_VERSION"] = FORMAL_VERSION = "#{SemVer.new(version.major, version.minor, version.patch).format "%M.%m.%p"}"

		puts version.to_s
		puts BUILD_VERSION		
		puts ASSEMBLY_VERSION
		puts FORMAL_VERSION		
	end
	
	task :all => [:init, :current_version]
end