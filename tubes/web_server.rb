require 'webrick'
include WEBrick

s = HTTPServer.new :Port => 8000, :DocumentRoot => Dir.pwd
trap('INT') {s.shutdown}
s.start
