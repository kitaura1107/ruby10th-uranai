require 'webrick'
require './controller/uranai'
require './controller/result'

server = WEBrick::HTTPServer.new(Port: 8000)

server.mount '/img', WEBrick::HTTPServlet::FileHandler, './img'
server.mount '/CSS', WEBrick::HTTPServlet::FileHandler, './CSS'
server.mount '/result.json', WEBrick::HTTPServlet::FileHandler, './result.json'

server.mount_proc '/' do |req, res|
  Routes::Uranai.call(req, res)
end

server.mount_proc '/result' do |req, res|
  Routes::Result.call(req, res)
end

trap('INT') { server.shutdown }
puts "http://localhost:8000"
server.start
