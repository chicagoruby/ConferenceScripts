require 'nokogiri'
require 'erb'
require 'json'
require 'read_helper'

include Nokogiri
include ERB::Util

ProgPath = "/Users/ghendry/Programming/chirbNoSQL/"
DataPath = ProgPath + "Stack Overflow Data Dump - Jun 10/Content/052010 SO/"

class PostCallbacks < XML::SAX::Document

  def start_document
    @results, @ids, @num = [], [], 0
  end
  def start_element(element, attributes)
    if element == 'row' 
      @num += 1
      puts @num if @num % 10000 == 0
      if attr_find(attributes,'Tags').include?('nosql') then
        row_hash = {}
        ['Id','CreationDate','OwnerUserId'].each {|key| row_hash[key] = attr_find(attributes,key)}      
        row_hash['Tags'] = tag_split(attr_find(attributes,'Tags'))
        row_hash['Body'] = h(attr_find(attributes,'Body'))
        @results << row_hash
        @ids << attr_find(attributes,'Id').strip
      end
    end
  end
  def end_document
    emit_json('posts', @results)
    emit_xml('posts', @results)
    emit_list('post_ids', @ids)
  end
end

parser = XML::SAX::Parser.new(PostCallbacks.new)
parser.parse_file(DataPath + "posts.xml")
       
