require 'test_helper'

class ClientTest < Minitest::Test

  def setup
    @model_class = MiniTest::Mock.new
    @class       = Myob::Api::Client
    @client      = Myob::Api::Client.new({})
  end

  def test_define_model_method_creates_instance_method
    @model_class.expect(:name, 'TestModel')
    @class.define_model_method(@model_class)
    @model_class.verify
    assert_respond_to @client, :test_model
    assert_kind_of Myob::Api::Query, @client.test_model
  end
  
end
