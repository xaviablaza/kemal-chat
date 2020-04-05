require "kemal"
require "mongo"
require "http"
require "./message"
require "./mongo_client"

SOCKETS = [] of HTTP::WebSocket
CLIENT = MongoClient.new(
  username: "root",
  password: "example",
  host: "localhost",
  port: 27017_u16,
  database: "kemal"
)

get "/" do
  render "views/index.ecr"
end

ws "/chat" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket

  # Broadcast each message to all clients
  socket.on_message do |message|
    data = Message.new(author_name: "anonymous", content: message)
    CLIENT.insert(data.to_h, collection: "messages")

    SOCKETS.each { |socket| socket.send message}
  end

  # Remove clients from the list when it's closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

post "/api/uploads" do |http_ctx|
  # puts http_ctx.request.body
  body = http_ctx.request.body
  puts body.as(IO).gets_to_end
  #if body = http_ctx.request.body
  #  parser = HTTP::FormData::Parser.new(body, "aA40")
  #  parser.next do |part|
  #    puts part.name
  #    puts part.body.gets_to_end
  #    puts part.filename
  #    puts part.size
  #    puts part.headers["Content-Type"]
  #  end
  #end
end

get "/api/uploads/:id/messages" do
end

post "/api/uploads/:id/messages" do
end

Kemal.run
