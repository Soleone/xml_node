require 'rubygems'
require 'active_support'
require "test/unit"

require File.dirname(__FILE__) + "/../lib/xml_node"

class TestXmlNode < Test::Unit::TestCase
  
  FEED_WITH_3_ELEMENTS = '<feed><elem>1</elem><elem>2</elem><elem>3</elem></feed>'
  
  def test_parse_sanity    
    assert_raise(ArgumentError) { XmlNode.parse }
    assert_nothing_raised { XmlNode.parse('<feed/>') }
  end


  def test_parse_attributes
    node = XmlNode.parse('<feed attr="1"/>')
    assert_equal '1', node['attr']
    assert_equal nil, node['attr2']
  end
  
  def test_parse_children
    node = XmlNode.parse('<feed><element>text</element></feed>')
    assert_equal XmlNode, node.children['element'].class
    assert_equal 'text', node.children['element'].text
  end
  
  def test_enumerate_children
    count = 0
    XmlNode.parse('<feed><element>text</element><element>text</element></feed>').children.each { count += 1 }
    assert_equal 2, count
  end

  def test_find_first
    xml = XmlNode.parse(FEED_WITH_3_ELEMENTS)
    assert_equal '1', xml.find(:first, '//elem').text
  end

  def test_find_all
    xml = XmlNode.parse(FEED_WITH_3_ELEMENTS)
    assert_equal ['1', '2', '3'], xml.find(:all, '//elem').collect(&:text)
  end

	def test_get_children_count
		feed = XmlNode.parse(FEED_WITH_3_ELEMENTS)
		assert_equal feed.children.size, 3
		assert_equal feed.children.count, 3
	end

	def test_mixed_text_content
		mixed = '<comment><text>Ok this is <b>really</b> great</text></comment>'	
		xml = XmlNode.parse(mixed)
		text = xml.find(:first, 'text').text
		# should not only return the text before the first child-element
		assert_not_equal "Ok this is ", text
		# should have 2 text nodes and one element
		assert 3, text.children.count
	end
	
end