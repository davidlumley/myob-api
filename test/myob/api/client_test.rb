require 'test_helper'

class ClientTest < Minitest::Test

  class TestModel; end

  def setup
    @class  = Myob::Api::Client
    @client = Myob::Api::Client.new({})
  end

  def test_define_model_method_creates_instance_method
    @class.define_model_method(TestModel)
    assert_respond_to @client, :test_model
  end

end
