require 'test_helper'

class TestVersion < Minitest::Test

  def test_version_is_not_nil
    assert Myob::Api::VERSION
  end

end
