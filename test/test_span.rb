require 'helper'
require 'span'

class SpanTest < Minitest::Test

  def test_span_finish()
    tracer = nil
    span = Datadog::Span.new(tracer, 'my.op')
    assert span.start_time < Time.now.utc
    assert_equal(span.end_time, nil)
    span.finish()
    assert span.end_time < Time.now.utc
  end

  def test_span_ids()
    span = Datadog::Span.new(nil, 'my.op')
    assert span.span_id
    assert span.parent_id == 0
    assert span.trace_id == span.span_id
    assert_equal(span.name, 'my.op')
  end

  def test_span_with_parent()
    span = Datadog::Span.new(nil, 'my.op', {:parent_id=>12, :trace_id=>13})
    assert span.span_id
    assert_equal(span.parent_id, 12)
    assert_equal(span.trace_id, 13)
    assert_equal(span.name, 'my.op')
  end

  def test_span_block()
    start = Time.now.utc
    span = Datadog::Span.new(nil, 'my.op').trace do |s|
      assert_equal(s.name, 'my.op')
      assert_equal(s.end_time, nil)
    end

    assert span.end_time != nil
    assert span.end_time < Time.now.utc
    assert span.end_time > start
  end

end
