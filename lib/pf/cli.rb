require "thor"
require "yaml"
require "pf/cli/qiniu"

module PF
  class CLI < Thor
    desc "qiniu <command> [<args>]", "using qiniu service to manage files"
    subcommand 'qiniu', QiniuCommand
  end
end