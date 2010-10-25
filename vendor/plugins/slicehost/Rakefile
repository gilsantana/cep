begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "bcalloway-slicehost"
    s.summary = "Capistrano recipes for setting up and deploying to Slicehost"
    s.email = "josh@joshpeek.com, brandon@brandoncalloway.com"
    s.homepage = "http://github.com/bcalloway/slicehost"
    s.description = "Slicehost Capistrano recipes for configuring and managing your slice."
    s.authors = ["Joshua Peek, Brandon Calloway"]
    
    s.has_rdoc = false
    s.files    = Dir["README", "MIT-LICENSE", "lib/capistrano/ext/**/*"]
    s.add_dependency("capistrano", ["> 2.5.0"])
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end