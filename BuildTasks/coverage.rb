namespace :coverage do
	desc "Run Coverage"
	task :opencover => ["testing:unittest"] do
		FileList["./Testing/UnitTest/**/_stage/bin/*.Facts.dll"].each {|testasm|						
			sh "#{configatron.testing_settings.opencover_exe} -target:#{configatron.testing_settings.xunit_exe} -targetargs:#{File.expand_path(testasm)} /noshadow -output:#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testasm, '.*')}.coverage.xml -targetdir:#{File.expand_path(File.dirname(testasm))} -filter:+[PrograMatrix*]*"
			#(exec testasm do |cov|
			#	cov.command = configatron.testing_settings.opencover_exe
			#	cov.parameters "-target:#{configatron.testing_settings.xunit_exe} -targetargs:#{File.expand_path(testasm)} /noshadow -output:#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/#{File.basename(testasm, '.*')}.coverage.xml -targetdir:#{File.expand_path(File.dirname(testasm))} -filter:+[PrograMatrix*]*"			
			#end).invoke
		}
	end
	
	desc "Generate Coverage Report"
	task :reportgen => :opencover do 
		FileList["#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/*.coverage.xml"].each {|covfile|
			(exec covfile do |rpt|
				rpt.command = configatron.testing_settings.reportgenerator_exe
				rpt.parameters "-reports:#{covfile} -targetdir:#{configatron.app_settings.output_dir}/#{FORMAL_VERSION} -reporttypes:Xml;XmlSummary;Html;HtmlSummary"				
			end).invoke
		}
	end
	
	desc "Generate Build Report"
	task :buildreport do
		src_file = "#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/Summary.xml"
		target_file = "#{configatron.app_settings.output_dir}/#{FORMAL_VERSION}/Summary.html"
		unless uptodate?(target_file, src_file)
			puts "TRY THIS!!!"
		end
	end
	
	desc "Run all coverage tasks"
	task :all => [:opencover, :reportgen]	
end