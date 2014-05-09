

require "mpatch"

x = {}
(1..10000).each do |i|
  x["key#{i}"] = i
end

t=Time.now
x.map_hash{ |k,v| { k.to_sym => v.to_s } }
puts Time.now - t

var= {hello: "world",no: "yes"}
puts var

var= [[:hello, "world"],[:no, "yes"]].map_hash{|k,v| {k => v} }
puts var.inspect

# require 'debugger'
# debugger

var = { hello: "world",no: 'yes' }.include_hash?( no: 'yes' )
puts var

