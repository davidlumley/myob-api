require 'test_helper'

class QueryTest < Minitest::Test

  @queries = {
    :where    => 'field eq condition',
    :order_by => 'field',
    :limit    => 10,
    :offset   => 1,
  }

  def setup
    @model_class = MiniTest::Mock.new
    @query       = Myob::Api::Query.new(@model_class)
  end

  @queries.each do |query, condition|
    define_method("test_#{query}_method_assigns_parameter") do
      @query.send(query.to_sym, condition)
      assert_equal condition, @query.params[query]
    end

    define_method("test_#{query}_method_returns_query_class") do
      assert_kind_of Myob::Api::Query, @query.send(query.to_sym, condition)
    end
  end

  def test_all_method_calls_corresponding_model_method
    @model_class.expect(:all, [], [@query])
    @query.all
    @model_class.verify
  end

end
