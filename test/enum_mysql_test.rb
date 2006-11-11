require File.dirname(__FILE__) + '/test_helper'
require 'fixtures/enumeration'

class EnumerationsTest < Test::Unit::TestCase
  class EnumController < ActionController::Base
    def test1
      @test = Enumeration.new
      render :inline => "<%= input('test', 'severity')%>"
    end

    def test2
      @test = Enumeration.new
      render :inline => "<%= enum_radio('test', 'severity')%>"
    end
  end

  def setup
    Enumeration.connection.execute 'DELETE FROM enumerations'
  end
  
  def test_column_values
    columns = Enumeration.columns_hash
    color_column = columns['color']
    assert color_column
    assert_equal [:red, :blue, :green, :yellow], color_column.values

    severity_column = columns['severity']
    assert severity_column
    assert_equal [:low, :medium, :high, :critical], severity_column.values
    assert_equal :medium, severity_column.default
  end

  def test_insert_enum
    row = Enumeration.new
    row.color = :blue
    row.string_field = 'test'
    assert_equal :medium, row.severity
    assert row.save

    db_row = Enumeration.find(row.id)
    assert db_row
    assert :blue, row.color
    assert :medium, row.severity
  end

  # Uses the automatic validates_columns to create automatic validation rules
  # for columns based on the schema information.
  def test_bad_value
    row = Enumeration.new
    row.color = :violet
    row.string_field = 'test'
    assert !row.save
    
    assert row.errors
    assert_equal 'is not included in the list', row.errors['color']
  end

  def test_other_types
    row = Enumeration.new
    row.string_field = 'a' * 10
    assert !row.save
    assert_equal 'is too long (maximum is 8 characters)', row.errors['string_field']

    row = Enumeration.new
    assert !row.save
    assert_equal 'can\'t be blank', row.errors['string_field']

    row = Enumeration.new
    row.string_field = 'test'
    row.int_field = 'aaaa'
    assert !row.save
    assert_equal 'is not a number', row.errors['int_field']

    row = Enumeration.new
    row.string_field = 'test'
    row.int_field = '500'
    assert row.save
  end

  def test_view_helper
    request  = ActionController::TestRequest.new
    response = ActionController::TestResponse.new
    request.action = 'test1'
    body = EnumController.process(request, response).body
    assert_equal '<select id="test_severity" name="test[severity]"><option value="low">low</option><option value="medium" selected="selected">medium</option><option value="high">high</option><option value="critical">critical</option></select>', body
  end

  def test_radio_helper
    request  = ActionController::TestRequest.new
    response = ActionController::TestResponse.new
    request.action = 'test2'
    body = EnumController.process(request, response).body
    assert_equal '<label>low: <input id="test_severity_low" name="test[severity]" type="radio" value="low" /></label><label>medium: <input checked="checked" id="test_severity_medium" name="test[severity]" type="radio" value="medium" /></label><label>high: <input id="test_severity_high" name="test[severity]" type="radio" value="high" /></label><label>critical: <input id="test_severity_critical" name="test[severity]" type="radio" value="critical" /></label>', body
  end
end
