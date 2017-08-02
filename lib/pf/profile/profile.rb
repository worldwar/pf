require "yaml"

module PF
  class Profile

    attr_accessor :qiniu

    def initialize
      @qiniu = QiniuProfile.new(self)
    end

    def save
      file = self.class.profile_file_for_write
      file.write(to_yaml)
      file.close
    end

    def self.profile_path
      pf_home = File.join(Dir.home(), '.pf')
      File.join(pf_home, "profile.yaml")
    end

    def self.create_profile_if_not_exist
      path = profile_path
      require 'fileutils'
      unless File.directory?(File.dirname(path))
        FileUtils.mkdir_p(File.dirname(path))
      end
      unless File.exist?(path)
        Profile.new.save
      end
    end

    def self.profile_file_for_write
      File.open(profile_path, "w+")
    end

    def self.profile
      create_profile_if_not_exist
      file = profile_path
      YAML.load_file(file)
    end

    def self.qiniu
      profile.qiniu
    end
  end

  class QiniuProfile
    attr_accessor :default_account, :accounts

    def initialize(parent)
      @parent = parent
      @accounts = []
    end

    def exist_account?(name)
      !account(name).nil?
    end

    def account(name=nil)
      name = @default_account if name.nil?
      @accounts.find { |account| account.name == name}
    end

    def save
      @parent.save
    end
  end

  class SecretKeyAccount
    attr_accessor :name, :access_key, :secret_key
    def initialize(name, access_key, secret_key)
      @name = name
      @access_key = access_key
      @secret_key = secret_key
    end
  end
end