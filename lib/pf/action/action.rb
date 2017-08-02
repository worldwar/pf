require 'qiniu'

module PF
  class Action
    attr_accessor :account
    def initialize(account)
      @account = account
    end
    def push(file, bucket)
      Qiniu.establish_connection! access_key: account.access_key,
                                  secret_key: account.secret_key
      key = File.basename(file)
      put_policy = Qiniu::Auth::PutPolicy.new(
          bucket,
          key,
          3600
      )

      uptoken = Qiniu::Auth.generate_uptoken(put_policy)

      filePath = file
      code, result, response_headers = Qiniu::Storage.upload_with_token_2(
          uptoken,
          filePath,
          key,
          nil,
          bucket: bucket
      )
    end
  end
end