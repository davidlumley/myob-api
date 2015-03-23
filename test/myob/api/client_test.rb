require 'test_helper'

class ClientTest < Minitest::Test

  def setup
    @client = Myob::Api::Client.new({})
  end

end
