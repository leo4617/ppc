class String
  def snake_case
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
class Hash
  def filter_and_replace_key(key_new, key_old)
    if value = self.delete(key_old)
      self[key_new] = value 
    end
    self
  end
end
