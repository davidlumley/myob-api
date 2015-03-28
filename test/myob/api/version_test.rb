require 'test_helper'

class VersionTest < Minitest::Test

  def test_version_is_not_nil
    assert Myob::Api::VERSION
  end

end
