require "thor"
require "pf/profile/profile"
require "pf/action/box_action"
require "pf/cli/command_base"

module PF
  class BoxAccountCommand < CommandBase

    @@myself = "account"

    desc "account add <account_name> <client_id> <client_secret>", "add box account"
    option :default, :type => :boolean
    def add(name, client_id, client_secret)
      BoxAction.add_account(name, client_id, client_secret)
    end

    default_task :list

    desc "account list", "list all box accounts"
    def list()
      box = Profile.box
      default_account = box.default_account
      puts "box accounts(#{box.accounts.size}):"
      puts
      box.accounts.each do |account|
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
      BoxAction.remove_account(account_name)
    end
  end
end
