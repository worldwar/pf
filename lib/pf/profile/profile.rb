require "yaml"

module PF
  class Profile

    attr_accessor :qiniu, :box

    def initialize
      @qiniu = QiniuProfile.new(self)
      @box = BoxProfile.new(self)
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

    def self.box
      p = profile
      if p.box.nil?
        p.box = BoxProfile.new(p)
      end
      p.save
      p.box
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

    def remove_account(name)
      @accounts.delete_if{|account| account.name == name}
      update_default
    end

    def update_default(name: nil)
      if name.nil?
        if @default_account.nil?
          unless @accounts.empty?
            @default_account = @accounts.first.name
          end
        else
          if @accounts.empty?
            @default_account = nil
          else
            if account.nil?
              @default_account = @accounts.first.name
            end
          end
        end
      else
        if exist_account? name
          @default_account = name
        else
          update_default
        end
      end
    end

    def add_account(new_account, default: true)
      updated = true
      account = account(new_account.name)

      if account.nil?
        @accounts.push(new_account)
      else
        if account.equal? new_account
          updated = false
        else
          # remove_account(new_account.name)
          @accounts.delete_if{|a| a.name == new_account}
          @accounts.unshift(new_account)
        end
      end

      if default
        @default_account = new_account.name
      end

      update_default
      updated
    end

    def save
      @parent.save
    end
  end

  class BoxProfile < QiniuProfile

  end

  class SecretKeyAccount
    attr_accessor :name, :access_key, :secret_key, :default_bucket
    def initialize(name, access_key, secret_key)
      @name = name
      @access_key = access_key
      @secret_key = secret_key
    end

    def equal?(other)
      @name == other.name and @access_key == other.access_key and @secret_key = other.secret_key
    end
  end

  class OAuth2Account
    attr_accessor :name, :client_id, :client_secret, :access_token, :refresh_token

    def initialize(name, client_id, client_secret, access_token: nil, refresh_token: nil)
      @name = name
      @client_id = client_id
      @client_secret = client_secret
      @access_token = access_token
      @refresh_token = refresh_token
    end

    def equal?(other)
      @name == other.name and @client_id = other.client_id and @client_secret = other.client_secret
    end
  end
end