class MongoClient
  def initialize(*, username : String, password : String, host : String, port : UInt16, database : String)
    @client = Mongo::Client.new "mongodb://#{username}:#{password}@#{host}:#{port}"
    @database = database
  end

  def insert(data, *, collection : String)
    @client[@database][collection].insert data
  end
end
