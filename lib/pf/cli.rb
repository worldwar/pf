require "thor"
require "yaml"
require "pf/cli/qiniu"
require "pf/cli/box"

module PF
  class CLI < Thor
    desc "qiniu <command> [<args>]", "using qiniu service to manage files"
    subcommand 'qiniu', QiniuCommand

    desc "box <command> [<args>]", "using box service to manage files"
    subcommand 'box', BoxCommand
  end
end