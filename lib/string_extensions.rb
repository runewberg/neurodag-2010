require 'htmlentities'

class String
  def decode
    coder = HTMLEntities.new
    coder.decode(self)
  end
end