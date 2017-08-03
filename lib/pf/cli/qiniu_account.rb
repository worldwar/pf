require "thor"
require "pf/profile/profile"
require "pf/action/action"
require "pf/cli/qiniu"
require "pf/cli/command_base"

module PF
  class QiniuAccountCommand < CommandBase

    @@myself = "account"

    desc "account add <account_name> <access_key> <secret_key>", "add qiniu account"
    option :default, :type => :boolean
    def add(name, access_key, secret_key)
      qiniu = Profile.qiniu
      if qiniu.exist_account?(name)
        qiniu.account(name).access_key = access_key
        qiniu.account(name).secret_key = secret_key
      else
        account = SecretKeyAccount.new(name, access_key, secret_key)
        qiniu.accounts.push(account)
        if qiniu.accounts.size == 1 or options[:default]
          qiniu.default_account = name
        end
      end
      qiniu.save
    end

    default_task :list

    desc "account list", "list all qiniu accounts"
    def list()
      qiniu = Profile.qiniu
      default_account = qiniu.default_account
      puts "qiniu accounts(#{qiniu.accounts.size}):"
      puts
      qiniu.accounts.each do |account|
        if account.name == default_account
          print "   * "
        else
          print "     "
        end
        puts account.name
      end
    end

    desc "account rm <account_name>", "remove specified account"
    def rm(account_name)
      qiniu = Profile.qiniu
      count = qiniu.accounts.size
      qiniu.accounts.delete_if{|account| account.name == account_name}
      if count == qiniu.accounts.size
        puts "can't find account '#{account_name}'"
        return
      else
        puts "account '#{account_name}' removed."
        if account_name == qiniu.default_account
          qiniu.default_account = qiniu.accounts[0].name unless qiniu.accounts.empty?
        end
        qiniu.save
      end
    end
  end
end
