
def load_list(fname)
  id_list = []
  File.open(ProgPath + fname) {|f| id_list = f.readlines} 
  id_list.each {|id| id.chomp!}
  id_list
end

def attr_find(arr, attr_name)
  ix = arr.find_index(attr_name)
  return arr[ix + 1] if !ix.nil? && ix < arr.size
  ''
end

def tag_split(tags)
  result = tags.split("><")
  if result.size > 0
    result[0].delete!('<')
    result[result.size - 1].chop!
  end
  result
end

def emit_json(name, data)
  File.open(ProgPath + name + '.json','w') {|f| f.puts Hash[name,data].to_json}
end

def emit_xml(name, data)
  builder = XML::Builder.new do |xml|        
    xml.send(name.to_sym) { data.each {|item| xml.row(item)} }
  end 
  File.open(ProgPath + name + '.xml','w') {|f| f.puts builder.to_xml}	
end

def emit_list(name, data)
  File.open(ProgPath + name + '.out','w') {|f| f.puts data}
end

