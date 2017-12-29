require 'date'

class DateTransformer
  DAYS = %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]

  def self.transform(date_string)
    with_year = date_string.match(/\w{3} \w{1,2}, 20\d{2}/).to_s
    without_year = (date_string.match(/(\w{3} \d{1,2})/) || "")[1] || ""

    case
    when date_string.downcase == "online now" then return Date.today
    when date_string.include?("Today") then return Date.today
    when date_string.match(/\A\d{1,2}:\d{2}/) then return Date.today
    when date_string.include?("Yesterday") then return Date.today - 1
    when includes_day?(date_string) then return Date.parse(matching_day(date_string)) - 7
    when with_year != "" then return Date.parse(with_year)
    else
      Date.parse(without_year)
    end
  end

  def self.includes_day?(string)
    DAYS.any? { |day| string.include?(day) }
  end

  def self.matching_day(string)
    DAYS.find { |day| string.include?(day) }
  end

  def self.handle_last_contacted(doc)
    if doc.css(".userinfo2015-basics-username-online-icon")[0].attributes["data-tooltip"]
      last_contacted = doc.css(".userinfo2015-basics-username-online-icon")[0].attributes["data-tooltip"].value
      last_contacted.sub!("Last contacted ","")
      DateTransformer.transform(last_contacted)
    else
      ''
    end
  end
end
