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

end
