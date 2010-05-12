require 'nokogiri'
require 'erb'
require 'json'
require 'read_helper'

include Nokogiri
include ERB::Util

ProgPath = "/Users/ghendry/Programming/chirbNoSQL/"
DataPath = ProgPath + "/Stack Overflow Data Dump - Jun 10/Content/052010 SO/"

class CommentsCallbacks < XML::SAX::Document

  def start_document
    @results, @num = [], 0
    @idlist = load_list('post_ids.out') + load_list('answer_ids.out')
  end
  def start_element(element, attributes)
    if element == 'row' 
      @num += 1
      puts @num if @num % 10000 == 0
      if @idlist.include?(attr_find(attributes,'PostId').strip) then
        p attributes 
        puts "id is #{attr_find(attributes, 'Id')} " 
        row_hash = {}
        ['Id','PostId','CreationDate','UserId'].each {|key| row_hash[key] = attr_find(attributes,key)}      
        row_hash['Body'] = h(attr_find(attributes,'Text'))
        @results << row_hash
      end
    end
  end
  def end_document
    emit_json('comments', @results)
    emit_xml('comments', @results)
  end
end

parser = XML::SAX::Parser.new(CommentsCallbacks.new)
parser.parse_file(DataPath + "comments.xml")
       
