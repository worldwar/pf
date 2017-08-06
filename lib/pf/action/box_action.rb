require 'boxr'
require 'pf/profile/profile'

module PF
  class BoxAction
    def self.push(file, folder: "/")
      box = Profile.box
      if box.account.access_token.nil?
        refresh box.default_account
      end
      client = client(box.default_account)
      box_folder = client.folder_from_path(folder)
      box_file = client.upload_file(file, box_folder)
      updated_file = client.create_shared_link_for_file(box_file, access: :open)
      puts "Shared Link: #{updated_file.shared_link.url}"
    end

    def self.add_account(name, client_id, client_secret)
      box = Profile.box
      account = OAuth2Account.new(name, client_id, client_secret)
      updated = box.add_account(account)
      box.save
      if updated
        refresh(name)
      end
    end

    def self.remove_account(name)
      box = Profile.box
      box.remove_account(name)
      box.save
    end

    def self.refresh(name)
      box = Profile.box
      account = box.account(name)
      if account.access_token.nil?
        oauth_url = Boxr::oauth_url('Dig-that-hole-forget-the-sun', client_id: account.client_id)
        puts "Your authorization url is: "
        puts
        puts oauth_url
        puts
        puts <<-EOF
copy the url above and paste it into your browser,
press enter, and click 'Grant access to Box' button.
After the broswer jumps to the redirect url of your app,
copy the url in your browser's address bar and paste it here.
        EOF

        print "The url in your browser's address bar is: "
        code = STDIN.gets.chomp.split('=').last
        tokens = Boxr::get_tokens(code, client_id: account.client_id, client_secret: account.client_secret)
        account.refresh_token = tokens.refresh_token
        account.access_token = tokens.access_token
        box.save
      end
    end

    def self.make_account_refresh_callback(name)
      lambda  do |access, refresh, identifier|
        puts "update access_token(#{access}) and refresh_token(#{refresh})"
        box = Profile.box
        account = box.account(name)
        account.access_token = access
        account.refresh_token = refresh
        box.save
      end
    end

    def self.client(name)
      box = Profile.box
      account = box.account(name)
      callback = make_account_refresh_callback(name)
      Boxr::Client.new(account.access_token,
                                refresh_token: account.refresh_token,
                                client_id: account.client_id,
                                client_secret: account.client_secret,
                                &callback)

    end
  end
end
