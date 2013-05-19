desc "Run the Code Stream Tests"
task :test do
  $success = system("xctool -workspace 'Code Stream.xcworkspace' -scheme 'Code StreamTests' test -test-sdk iphonesimulator")
  puts "\033[0;31m!! iOS unit tests failed" unless $success
  
  if $success
	puts "\033[0;32m** All tests executed successfully"
  else
	exit(-1)
  end
end

task :default => 'test'
