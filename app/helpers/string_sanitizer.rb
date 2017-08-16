module StringSanitizer
  refine String do
    def sanitize!
      self.strip!
      self.better_quotation_marks!
      self.eliminate_weird_chars!
      self
    end

    def better_quotation_marks!
      self.gsub!("’","'")
      self.gsub!('”','"')
      self
    end

    def eliminate_weird_chars!
      self.gsub!(' ', '')
      self
    end
  end
end
