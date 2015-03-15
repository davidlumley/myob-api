require 'test_helper'

class TestHelpers < Minitest::Test

  def test_underscore_correctly_formats_string
    assert_equal 'underscored_successfully',
      'UnderscoredSuccessfully'.underscore
  end

end
