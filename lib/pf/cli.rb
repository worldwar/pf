require "thor"
require "yaml"
require "pf/cli/qiniu"
require "pf/cli/box"
require "tty-table"

module PF
  class CLI < Thor
    desc "qiniu <command> [<args>]", "using qiniu service to manage files"
    subcommand 'qiniu', QiniuCommand

    desc "box <command> [<args>]", "using box service to manage files"
    subcommand 'box', BoxCommand

    desc "service <command> [<args>]", "using box service to manage files"
    def services
      services = [
          {
              :name => "box",
              :home => "https://box.com/home",
              :desc => "A cloud content management and file sharing service, based in Redwood City, California"
          },
          {
              :name => "qiniu",
              :home => "https://qiniu.com",
              :desc => "A cloud-based storage solutions provider, based in Shanghai"
          }
      ]
      puts "pf supports following cloud storage services currently: "
      table = TTY::Table.new  services.map{|service|["", "- " + service[:name], service[:home], service[:desc]]}
      puts table.render(:basic, multiline: true, column_widths: [1, 10, 20, 40], padding: 1)
    end
  end
end