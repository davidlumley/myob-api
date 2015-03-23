require 'test_helper'

class BaseTest < Minitest::Test

  def setup
    @model = Myob::Api::Model::Base.new({})
  end

end
