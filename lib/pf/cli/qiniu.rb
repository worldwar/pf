require "thor"
require "pf/profile/profile"
require "pf/action/action"
require "pf/cli/qiniu_account"
require "pf/cli/command_base"

module PF
  class QiniuCommand < CommandBase

    @@myself = "qiniu"

    desc "push <filename> [<bucket_name>]", "upload file to qiniu service to <bucket_name>"
    def push(filepath, bucket=nil)
      qiniu = Profile.qiniu()
      account = qiniu.account()
      if account.nil?
        puts "You haven't add any qiniu accounts. Please add an qiniu account before push"
        return
      end

      if bucket.nil?
        bucket = account.default_bucket
        if bucket.nil?
          puts "pass bucket name in command line, like 'pf qiniu push FILENAME BUCKET_NAME',"
          "or set default qiniu bucket using 'pf qiniu default bucket BUCKET_NAME' before push"
          return
        end
      end

      action = Action.new(account)
      action.push(filepath, bucket)
    end

    desc "account <subcommand> [argv]", "manage qiniu accounts"
    subcommand "account", QiniuAccountCommand
  end
end


