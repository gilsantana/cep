$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'paperclip'

include_files = ["README*", "LICENSE", "Rakefile", "init.rb", "{generators,lib,tasks,test,shoulda_macros}/**/*"].map do |glob|
  Dir[glob]
end.flatten
exclude_files = ["test/s3.yml", "test/debug.log", "test/paperclip.db", "test/doc", "test/doc/*", "test/pkg", "test/pkg/*", "test/tmp", "test/tmp/*"].map do |glob|
  Dir[glob]
end.flatten

spec = Gem::Specification.new do |s| 
  s.name              = "paperclip-cloudfiles"
  s.version           = Paperclip::VERSION
  s.authors           = ["Jon Yurek","H. Wade Minter"]
  s.email             = ["jyurek@thoughtbot.com", "minter@lunenburg.org"]
  s.homepage          = "http://github.com/minter/paperclip"
  s.description       = "Easy upload management for ActiveRecord with Rackspace Cloud Files support"
  s.platform          = Gem::Platform::RUBY
  s.summary           = "File attachments as attributes for ActiveRecord with Rackspace Cloud Files support"
  s.files             = include_files - exclude_files
  s.require_path      = "lib"
  s.test_files        = Dir["test/**/test_*.rb"]
  s.rubyforge_project = "paperclip"
  s.has_rdoc          = true
  s.extra_rdoc_files  = Dir["README*"]
  s.rdoc_options << '--line-numbers' << '--inline-source'
  s.requirements << "ImageMagick"
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'aws-s3'
  s.add_development_dependency 'cloudfiles'
  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'active_record'
  s.add_development_dependency 'active_support'
end

