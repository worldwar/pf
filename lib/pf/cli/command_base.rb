require "thor"

module PF
  class CommandBase < Thor
    @@myself = '<subcommand>'

    def self.banner(command, namespace = nil, subcommand = false)
      "#{basename} #{@@myself} #{command.usage}"
    end
  end
end
