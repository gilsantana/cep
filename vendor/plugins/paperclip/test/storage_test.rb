require 'test/helper'
require 'aws/s3'

class StorageTest < Test::Unit::TestCase
  def rails_env(env)
    silence_warnings do
      Object.const_set(:Rails, stub('Rails', :env => env))
    end
  end

  context "Parsing S3 credentials" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :bucket => "testing",
                    :s3_credentials => {:not => :important}

      @dummy = Dummy.new
      @avatar = @dummy.avatar
    end

    should "get the correct credentials when RAILS_ENV is production" do
      rails_env("production")
      assert_equal({:key => "12345"},
                   @avatar.parse_credentials('production' => {:key => '12345'},
                                             :development => {:key => "54321"}))
    end

    should "get the correct credentials when RAILS_ENV is development" do
      rails_env("development")
      assert_equal({:key => "54321"},
                   @avatar.parse_credentials('production' => {:key => '12345'},
                                             :development => {:key => "54321"}))
    end

    should "return the argument if the key does not exist" do
      rails_env("not really an env")
      assert_equal({:test => "12345"}, @avatar.parse_credentials(:test => "12345"))
    end
  end
  
  context "Parsing Cloud Files credentials" do
    setup do
      CloudFiles::Connection.stubs(:new).returns(true)
      
      rebuild_model :storage => :cloud_files,
                    :bucket => "testing",
                    :cloudfiles_credentials => {:not => :important}

      
      @dummy = Dummy.new
      @avatar = @dummy.avatar
      @current_env = RAILS_ENV
    end

    teardown do
      Object.const_set("RAILS_ENV", @current_env)
    end

    should "get the correct credentials when RAILS_ENV is production" do
      Object.const_set('RAILS_ENV', "production")
      assert_equal({:username => "minter"},
                   @avatar.parse_credentials('production' => {:username => 'minter'},
                                             :development => {:username => "mcornick"}))
    end

    should "get the correct credentials when RAILS_ENV is development" do
      Object.const_set('RAILS_ENV', "development")
      assert_equal({:key => "mcornick"},
                   @avatar.parse_credentials('production' => {:key => 'minter'},
                                             :development => {:key => "mcornick"}))
    end

    should "return the argument if the key does not exist" do
      Object.const_set('RAILS_ENV', "not really an env")
      assert_equal({:test => "minter"}, @avatar.parse_credentials(:test => "minter"))
    end
  end
  

  context "" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :s3_credentials => {},
                    :bucket => "bucket",
                    :path => ":attachment/:basename.:extension",
                    :url => ":s3_path_url"
      @dummy = Dummy.new
      @dummy.avatar = StringIO.new(".")
    end

    should "return a url based on an S3 path" do
      assert_match %r{^http://s3.amazonaws.com/bucket/avatars/stringio.txt}, @dummy.avatar.url
    end
  end

  context "" do
    setup do
      container = mock
      container.stubs(:make_public).returns(true)
      container.stubs(:public_url).returns('http://c0010181.cdn.cloudfiles.rackspacecloud.com/avatars/stringio.txt') 
      container.stubs(:cdn_url).returns('http://c0010181.cdn.cloudfiles.rackspacecloud.com')
      connection = mock
      connection.stubs(:create_container).returns(container)
      CloudFiles::Connection.expects(:new).returns(connection)
      
      rebuild_model :storage => :cloud_files,
                    :cloudfiles_credentials => {},
                    :container => "container",
                    :path => ":attachment/:basename.:extension"
      @dummy = Dummy.new
      @dummy.avatar = StringIO.new(".")
    end

    should "return a url based on an Cloud Files path" do
      assert_match %r{^http://c0010181.cdn.cloudfiles.rackspacecloud.com/avatars/stringio.txt}, @dummy.avatar.url
    end
  end
  
  
  context "" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :s3_credentials => {},
                    :bucket => "bucket",
                    :path => ":attachment/:basename.:extension",
                    :url => ":s3_domain_url"
      @dummy = Dummy.new
      @dummy.avatar = StringIO.new(".")
    end

    should "return a url based on an S3 subdomain" do
      assert_match %r{^http://bucket.s3.amazonaws.com/avatars/stringio.txt}, @dummy.avatar.url
    end
  end
  
  context "" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :s3_credentials => {
                      :production   => { :bucket => "prod_bucket" },
                      :development  => { :bucket => "dev_bucket" }
                    },
                    :s3_host_alias => "something.something.com",
                    :path => ":attachment/:basename.:extension",
                    :url => ":s3_alias_url"
      @dummy = Dummy.new
      @dummy.avatar = StringIO.new(".")
    end

    should "return a url based on the host_alias" do
      assert_match %r{^http://something.something.com/avatars/stringio.txt}, @dummy.avatar.url
    end
  end

  context "Generating a url with an expiration" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :s3_credentials => {
                      :production   => { :bucket => "prod_bucket" },
                      :development  => { :bucket => "dev_bucket" }
                    },
                    :s3_host_alias => "something.something.com",
                    :path => ":attachment/:basename.:extension",
                    :url => ":s3_alias_url"

      rails_env("production")

      @dummy = Dummy.new
      @dummy.avatar = StringIO.new(".")

      AWS::S3::S3Object.expects(:url_for).with("avatars/stringio.txt", "prod_bucket", { :expires_in => 3600 })

      @dummy.avatar.expiring_url
    end

    should "should succeed" do
      assert true
    end
  end

  context "Parsing S3 credentials with a bucket in them" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :s3_credentials => {
                      :production   => { :bucket => "prod_bucket" },
                      :development  => { :bucket => "dev_bucket" }
                    }
      @dummy = Dummy.new
    end

    should "get the right bucket in production" do
      rails_env("production")
      assert_equal "prod_bucket", @dummy.avatar.bucket_name
    end

    should "get the right bucket in development" do
      rails_env("development")
      assert_equal "dev_bucket", @dummy.avatar.bucket_name
    end
  end
  
  context "Parsing Cloud Files credentials with a container in them" do
    setup do
      #CloudFiles::Connection.expects(:new).returns(true)
      #CloudFiles::Connection.any_instance.stubs(:create_container).returns(true)
      rebuild_model :storage => :cloud_files,
                    :cloudfiles_credentials => {
                      :production   => { :container => "prod_container" },
                      :development  => { :container => "dev_container" }
                    }
      @dummy = Dummy.new
      @old_env = RAILS_ENV
    end

    teardown{ Object.const_set("RAILS_ENV", @old_env) }

    should "get the right container in production" do
      Object.const_set("RAILS_ENV", "production")
      assert_equal "prod_container", @dummy.avatar.container_name
    end

    should "get the right bucket in development" do
      Object.const_set("RAILS_ENV", "development")
      assert_equal "dev_container", @dummy.avatar.container_name
    end
  end
  

  context "An attachment with S3 storage" do
    setup do
      rebuild_model :storage => :s3,
                    :bucket => "testing",
                    :path => ":attachment/:style/:basename.:extension",
                    :s3_credentials => {
                      'access_key_id' => "12345",
                      'secret_access_key' => "54321"
                    }
    end

    should "be extended by the S3 module" do
      assert Dummy.new.avatar.is_a?(Paperclip::Storage::S3)
    end

    should "not be extended by the Filesystem module" do
      assert ! Dummy.new.avatar.is_a?(Paperclip::Storage::Filesystem)
    end

    context "when assigned" do
      setup do
        @file = File.new(File.join(File.dirname(__FILE__), 'fixtures', '5k.png'), 'rb')
        @dummy = Dummy.new
        @dummy.avatar = @file
      end

      teardown { @file.close }

      should "not get a bucket to get a URL" do
        @dummy.avatar.expects(:s3).never
        @dummy.avatar.expects(:s3_bucket).never
        assert_match %r{^http://s3\.amazonaws\.com/testing/avatars/original/5k\.png}, @dummy.avatar.url
      end

      context "and saved" do
        setup do
          AWS::S3::S3Object.stubs(:store).with(@dummy.avatar.path, anything, 'testing', :content_type => 'image/png', :access => :public_read)
          @dummy.save
        end

        should "succeed" do
          assert true
        end
      end

      context "and remove" do
        setup do
          AWS::S3::S3Object.stubs(:exists?).returns(true)
          AWS::S3::S3Object.stubs(:delete)
          @dummy.destroy_attached_files
        end

        should "succeed" do
          assert true
        end
      end
    end
  end
  
  context "An attachment with Cloud Files storage" do
    setup do
      rebuild_model :storage => :cloud_files,
                    :container => "testing",
                    :path => ":attachment/:style/:basename.:extension",
                    :cloudfiles_credentials => {
                      'username' => "minter",
                      'api_key' => "xxxxxxx"
                    }
    end

    should "be extended by the CloudFile module" do
      CloudFiles::Connection.stubs(:new).returns(true)
      assert Dummy.new.avatar.is_a?(Paperclip::Storage::CloudFile)
    end

    should "not be extended by the Filesystem module" do
      CloudFiles::Connection.stubs(:new).returns(true)
      assert ! Dummy.new.avatar.is_a?(Paperclip::Storage::Filesystem)
    end

  #   context "when assigned" do
  #     setup do
  #       @cf_mock = stub
  #       CloudFiles::Connection.expects(:new).returns(@cf_mock)
  #       @file = File.new(File.join(File.dirname(__FILE__), 'fixtures', '5k.png'), 'rb')
  #       @dummy = Dummy.new
  #       @dummy.avatar = @file
  #     end
  # 
  #     teardown { @file.close }
  # 
  #     context "and saved" do
  #       setup do
  #         @container_mock = stub
  #         @object_mock = stub
  #         @cf_mock.expects(:create_container).with("testing").returns(@container_mock)
  #         @container_mock.expects(:make_public).returns(true)
  #         @container_mock.expects(:create_object).returns(@object_mock)
  #         @object_mock.expects(:write).returns(true)
  #         @dummy.save
  #       end
  #     
  #       should "succeed" do
  #         assert true
  #       end
  #     end
  #     
  #     context "and remove" do
  #       setup do
  #         @container_mock = stub
  #         print "DEBUG: ContainerMock is #{@container_mock}\n"
  #         @object_mock = stub
  #         print "DEBUG: Object  Mock is #{@object_mock}\n"
  #         @cf_mock.expects(:create_container).with("testing").returns(@container_mock)
  #         @container_mock.expects(:make_public).returns(true)
  #         @container_mock.stubs(:object_exists?).returns(true)
  #         @container_mock.expects(:delete_object).with('avatars/original/5k.png').returns(true)
  #         @dummy.destroy_attached_files
  #       end
  #     
  #       should "succeed" do
  #         assert true
  #       end
  #     end
  #   end
  end
  
  
  context "An attachment with S3 storage and bucket defined as a Proc" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :bucket => lambda { |attachment| "bucket_#{attachment.instance.other}" },
                    :s3_credentials => {:not => :important}
    end

    should "get the right bucket name" do
      assert "bucket_a", Dummy.new(:other => 'a').avatar.bucket_name
      assert "bucket_b", Dummy.new(:other => 'b').avatar.bucket_name
    end
  end
  
  context "An attachment with Cloud Files storage and container defined as a Proc" do
    setup do
      CloudFiles::Connection.stubs(:new).returns(true)
      rebuild_model :storage => :cloud_files,
                    :bucket => lambda { |attachment| "container_#{attachment.instance.other}" },
                    :cloudfiles_credentials => {:not => :important}
    end
    
    should "get the right container name" do
      assert "container_a", Dummy.new(:other => 'a').avatar.container_name
      assert "container_b", Dummy.new(:other => 'b').avatar.container_name
    end
  end
  

  context "An attachment with S3 storage and specific s3 headers set" do
    setup do
      AWS::S3::Base.stubs(:establish_connection!)
      rebuild_model :storage => :s3,
                    :bucket => "testing",
                    :path => ":attachment/:style/:basename.:extension",
                    :s3_credentials => {
                      'access_key_id' => "12345",
                      'secret_access_key' => "54321"
                    },
                    :s3_headers => {'Cache-Control' => 'max-age=31557600'}
    end

    context "when assigned" do
      setup do
        @file = File.new(File.join(File.dirname(__FILE__), 'fixtures', '5k.png'), 'rb')
        @dummy = Dummy.new
        @dummy.avatar = @file
      end

      teardown { @file.close }

      context "and saved" do
        setup do
          AWS::S3::Base.stubs(:establish_connection!)
          AWS::S3::S3Object.stubs(:store).with(@dummy.avatar.path,
                                               anything,
                                               'testing',
                                               :content_type => 'image/png',
                                               :access => :public_read,
                                               'Cache-Control' => 'max-age=31557600')
          @dummy.save
        end

        should "succeed" do
          assert true
        end
      end
    end
  end

  context "with S3 credentials supplied as Pathname" do
     setup do
       ENV['S3_KEY']    = 'pathname_key'
       ENV['S3_BUCKET'] = 'pathname_bucket'
       ENV['S3_SECRET'] = 'pathname_secret'

       rails_env('test')

       rebuild_model :storage        => :s3,
                     :s3_credentials => Pathname.new(File.join(File.dirname(__FILE__))).join("fixtures/s3.yml")

       Dummy.delete_all
       @dummy = Dummy.new
     end

     should "parse the credentials" do
       assert_equal 'pathname_bucket', @dummy.avatar.bucket_name
       assert_equal 'pathname_key', AWS::S3::Base.connection.options[:access_key_id]
       assert_equal 'pathname_secret', AWS::S3::Base.connection.options[:secret_access_key]
     end
  end

  context "with S3 credentials in a YAML file" do
    setup do
      ENV['S3_KEY']    = 'env_key'
      ENV['S3_BUCKET'] = 'env_bucket'
      ENV['S3_SECRET'] = 'env_secret'

      rails_env('test')

      rebuild_model :storage        => :s3,
                    :s3_credentials => File.new(File.join(File.dirname(__FILE__), "fixtures/s3.yml"))

      Dummy.delete_all

      @dummy = Dummy.new
    end

    should "run it the file through ERB" do
      assert_equal 'env_bucket', @dummy.avatar.bucket_name
      assert_equal 'env_key', AWS::S3::Base.connection.options[:access_key_id]
      assert_equal 'env_secret', AWS::S3::Base.connection.options[:secret_access_key]
    end
  end

  unless ENV["S3_TEST_BUCKET"].blank?
    context "Using S3 for real, an attachment with S3 storage" do
      setup do
        rebuild_model :styles => { :thumb => "100x100", :square => "32x32#" },
                      :storage => :s3,
                      :bucket => ENV["S3_TEST_BUCKET"],
                      :path => ":class/:attachment/:id/:style.:extension",
                      :s3_credentials => File.new(File.join(File.dirname(__FILE__), "s3.yml"))

        Dummy.delete_all
        @dummy = Dummy.new
      end

      should "be extended by the S3 module" do
        assert Dummy.new.avatar.is_a?(Paperclip::Storage::S3)
      end

      context "when assigned" do
        setup do
          @file = File.new(File.join(File.dirname(__FILE__), 'fixtures', '5k.png'), 'rb')
          @dummy.avatar = @file
        end

        teardown { @file.close }

        should "still return a Tempfile when sent #to_file" do
          assert_equal Tempfile, @dummy.avatar.to_file.class
        end

        context "and saved" do
          setup do
            @dummy.save
          end

          should "be on S3" do
            assert true
          end
        end
      end
    end
  end
  
  unless ENV["CF_TEST_BUCKET"].blank?
    context "Using CloudFiles for real, an attachment with CloudFiles storage" do
      setup do
        rebuild_model :styles => { :thumb => "100x100", :square => "32x32#" },
                      :storage => :cloud_files,
                      :container => ENV["CF_TEST_BUCKET"],
                      :path => ":class/:attachment/:id/:style.:extension",
                      :cloudfiles_credentials => File.new(File.join(File.dirname(__FILE__), "cloudfiles.yml"))

        Dummy.delete_all
        @dummy = Dummy.new
      end

      should "be extended by the CloudFile module" do
        assert Dummy.new.avatar.is_a?(Paperclip::Storage::CloudFile)
      end

      context "when assigned" do
        setup do
          @file = File.new(File.join(File.dirname(__FILE__), 'fixtures', '5k.png'), 'rb')
          @dummy.avatar = @file
        end

        teardown { @file.close }

        should "still return a Tempfile when sent #to_io" do
          assert_equal Tempfile, @dummy.avatar.to_io.class
        end

        context "and saved" do
          setup do
            @dummy.save
          end

          should "be on Cloud Files" do
            assert true
          end
        end
      end
    end
  end
  
end
