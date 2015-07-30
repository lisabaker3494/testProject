namespace :db do
	desc "Builds the migration project"
	msbuild :build do |msb|
		msb.properties :configuration => ENV["mode"] || :Debug
		msb.targets :Clean, :Build
		msb.solution = "Path/Migration.sln"
	end

	desc "Creates the database"
	sqlcmd :create do |sql|
		sql.command = "sqlcmd.exe"
		sql.server = "localhost"
		#sql.database = ""
		#sql.username = ""
		#sql.password = ""
		#sql.variables :New_DB_Name => "Albacore_Test"
		sql.scripts "./Path/Scripts/CreateDatabase.sql"
	end
	
	desc "Drops the database"
	sqlcmd :drop do |sql|
		sql.command = "sqlcmd.exe"
		sql.server = "localhost"	
		sql.scripts "./Path/Scripts/DropDatabase.sql"		
	end
	
	desc "Migration the database up to it's greatest version"
	task :up do
		Rake::Task["db:migrate"].invoke("migrate:up", ENV["version"] || 0, nil)
	end
	
	desc "Migration the database down to version"
	task :down do
		Rake::Task["db:migrate"].invoke("migrate:down", ENV["version"] || 0, nil)
	end	
	
	desc "Rollback"
	task :rollback do
		Rake::Task["db:migrate"].invoke("rollback", 0, ENV["steps"] || 1)
	end
	
	desc "Rollback to specific version "
	task :rollback do
		Rake::Task["db:migrate"].invoke("rollback:toversion", ENV["version"] || 0, nil)
	end
	
	desc "Rollback entire database"
	task :rollbackall do
		Rake::Task["db:migrate"].invoke("rollback:all")
	end
	
	desc "Migrates the database"
	fluentmigrator :migrate, [:task, :version, :steps] => ["db:build"] do |mig, args|
		args.with_defaults(:task => ENV["task"] || "migrate:up", :preview => (ENV["preview"] == "true") || false)
		mode = ENV["mode"] || :Debug
		instance = ENV["instance"] || "sqlexpress"
		
		mig.command = "./Path/FuluentMigrator.../Migrate.exe"
		mig.provider = "sqlserver2012"
		mig.target = "./Path/SchemaMigration.dll"
		#mig.connection = ""
		mig.connection = "Server=localhost;Database=Mydb;Trusted_Connection=True;"
		mig.verbose = true
		mig.task = args[:task]
		mig.preview = args[:preview]
		
		if args[:task] == "rollback" then
			mig.steps = args[:steps]
		end
		
		if args[:task] == "rollback:toversion" then
			mig.version = args[:version]
		end		
	end
end