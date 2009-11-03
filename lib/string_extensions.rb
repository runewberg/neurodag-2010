class String
  def decode
    CODER.decode(self)
  end

  def decode!
    self.decode
  end

end