require 'test_helper'

class HelpersTest < Minitest::Test

  @tests  = {
    :upper_camel_case => {
      :input  => 'UpperCamelCase',
      :output => 'upper_camel_case',
    },
    :lower_camel_case => {
      :input  => 'lowerCamelCase',
      :output => 'lower_camel_case',
    },
    :screaming_snake_case => {
      :input  => 'SCREAMING_SNAKE_CASE',
      :output => 'screaming_snake_case',
    },
    :snake_case => {
      :input  => 'snake_case',
      :output => 'snake_case',
    },
  }

  def setup
    @object = Object.new
    @object.extend(Myob::Api::Helpers)
  end

  @tests.each do |title, test_data|
    define_method("test_underscore_method_converts_#{title}_text") do
      assert_equal test_data[:output], @object.underscore(test_data[:input])
    end
  end



end
