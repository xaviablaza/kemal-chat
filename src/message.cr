class Message
  def initialize(*, author_name : String, content : String)
    @author_name = author_name
    @content = content
  end

  def author_name
    @author_name
  end

  def content
    @content
  end

  def to_h
    {"author_name" => @author_name, "content" => content}
  end
end
