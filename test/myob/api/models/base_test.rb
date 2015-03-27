require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @class = Myob::Api::Model::Base
    @model = Myob::Api::Model::Base.new({})
    @query = Object.new
  end

  def test_all_method_returns_array
    assert_kind_of Array, @class.all(@query)
  end

  def test_model_class_has_access_to_client_for_requests
    assert_respond_to @class, :client
  end

end
