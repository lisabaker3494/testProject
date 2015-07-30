namespace :testing do
	desc "Run Unit Tests"
	task :unittest do
		FileList["./Testing/UnitTest/**/_stage/bin/*.Facts.dll"].each {|testasm|		
			(xunit testasm do |xut|	
				xut.command = configatron.testing_settings.xunit_exe
				xut.assembly = testasm
				xut.options "/xml #{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testasm, ".*")}.results.xml"
				#html_output = "xunit_html_output"
				#xut.results_path = {:xml => "xunit_html_output" }
				#xut.outputpath = {:xml => "#{File.basename(testasm)}.results.xml"}
			end).invoke
		}
	end

	desc "Run Acceptance Tests"
	task :acetest do
		FileList["./Testing/FunctionalTest/**/_stage/bin/*.Specs.dll"].each {|testasm|		
			(xunit testasm do |xut|	
				xut.command = configatron.testing_settings.xunit_exe
				xut.assembly = testasm
				xut.options "/xml #{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testasm, ".*")}.results.xml"
			end).invoke
		}
	end	
	
	desc "Build Acceptance Test Report"
	task :sfreport do
		FileList["./Testing/FunctionalTest/**/*.Specs.csproj"].each {|testproj|
			(specflowreport testproj do |sfw|
				sfw.command = configatron.testing_settings.specflow_exe
				sfw.report = :nunitexecutionreport
				sfw.projects testproj	
				sfw.options "/xmlTestResult:#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testproj, ".*")}.results.xml /out:#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testproj, ".*")}.SpecflowExecutionReport.html"
			end).invoke
		}		
	end	
	
	desc "Run all testing tasks"
	task :all => [:unittest, :acetest, :sfreport]
end