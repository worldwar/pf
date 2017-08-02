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
  end
end
