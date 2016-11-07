class StringSanitizer

  def self.sanitize!(string)
    better_quotation_marks!(string)
    eliminate_weird_chars!(string)
    string.strip!
    string
  end

  private

  def self.better_quotation_marks!(string)
    string.gsub!("’","'")
    string.gsub!('”','"')
    return string
  end

  def self.eliminate_weird_chars!(string)
    string.gsub!(' ', '')
    return string
  end

end
