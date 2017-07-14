class CSV::RowAdder::Adapter
  using StringSanitizer

  attr_reader :file

  def initialize(file:)
    @file = file
  end

  def username
    file.css(".userinfo2015-basics-username").text.strip
  end

  def last_messaged
    DateTransformer.handle_last_contacted(file)
  end

  def match_percentage
    file.
      css(".userinfo2015-basics-asl").
      css(".userinfo2015-basics-asl-match a").
      text.
      gsub(" Match", "").
      gsub('%', '')
  end

  def all_basics
    basics = file.css(".details2015-section.basics td")[1].text
    basics.match(/(.*)(4’.|5’.|6’.)(.{1,2}”)(.*)/) || basics.match(/(.*)/)
  end

  def basics
    all_basics[1].sanitize!
  rescue
    'n/a'
  end

  def feet
    feet = all_basics[2] || ''
    feet.sub(/’/,'').sanitize!
  rescue
    'n/a'
  end

  def inches
    inches = all_basics[3] || ''
    inches.sub(/”/,'').sanitize!
  rescue
    'n/a'
  end

  def body
    body = all_basics[4] || ''
    body.sub(/, /, '').sanitize!
  rescue
    'n/a'
  end

  def lifestyle
    file.css(".details2015-section.misc td")[1].text.sanitize!
  end

  def last_online
    DateTransformer.
      transform(
        file.
          css(".userinfo2015-basics-username-online")[0].
          attributes["data-tooltip"].
          value
      )
  end

  def age
    file.css(".userinfo2015-basics-asl").css(".userinfo2015-basics-asl-age").text
  end

  def city
    file.
      css(".userinfo2015-basics-asl").
      css(".userinfo2015-basics-asl-location").
      text
  end

  def has_kids
    return unless lifestyle

    case lifestyle
    when /as kids/ then "TRUE"
    when /oesn't have kids/ then "FALSE"
    else
      "n/a"
    end
  end

  def wants_kids
    return unless lifestyle

    case lifestyle
    when /wants/ then "TRUE"
    when /might want/ then "MAYBE"
    when /oesn't want/ then "FALSE"
    else
      "n/a"
    end
  end

  def background
    file.css(".details2015-section.background td")[1].text.sanitize!
  end

  def description
    file.css(".essays2015-essay-content").text
  end
end
