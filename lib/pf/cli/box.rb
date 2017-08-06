require "thor"
require "pf/profile/profile"
require "pf/action/action"
require "pf/cli/box_account"
require "pf/cli/command_base"

module PF
  class BoxCommand < CommandBase

    @@myself = "box"

    desc "push <filename> [<folder_name>]", "upload file to box service to <folder_name>"
    def push(filepath, folder="/")
      if Profile.box().account().nil?
        puts "You haven't add any box accounts. Please add an box account before push"
        return
      end

      BoxAction.push(filepath, folder: folder)
    end

    desc "account <subcommand> [argv]", "manage box accounts"
    subcommand "account", BoxAccountCommand
  end
end


