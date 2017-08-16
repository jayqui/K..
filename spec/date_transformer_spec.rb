require_relative "../app/helpers/date_transformer"

describe DateTransformer do
  let(:online_now) { "Online Now" }
  let(:today)      { "Last online Today - 11:35am" }
  let(:yesterday)  { "Last online Yesterday - 3:22pm" }
  let(:thurs)      { "Last online Thursday - 8:19pm" }
  let(:dec30)      { "Last online Dec 30, 2015 8:27pm" }
  let(:jan2)       { "Last online Jan 2 10:08pm" }

  describe "#transform" do
    it "transforms 'Online Now' into Date.today" do
      expect(DateTransformer.transform(online_now)).to eq(Date.today)
    end

    it "transforms 'Last online Today ...' into Date.today" do
      expect(DateTransformer.transform(today)).to eq(Date.today)
    end

    it "transforms 'Last online Yesterday ...' into Date.today - 1" do
      expect(DateTransformer.transform(yesterday)).to eq(Date.today - 1)
    end

    it "transforms a /MMM DD YYYY/ date into the corresponding Ruby Date object" do
      expect(DateTransformer.transform(dec30)).to eq(Date.parse("Dec 30, 2015"))
    end

    it "transforms a /MMM DD/ date into the corresponding Ruby Date object" do
      expect(DateTransformer.transform(jan2)).to eq(Date.parse("Jan 2"))
    end

    it "transforms 'Last Online [day of week]...' into that day of week previous" do
      expect(DateTransformer.transform(thurs)).to eq(Date.parse("Thursday") - 7)
    end
  end

  describe "#includes_day?" do
    it "should say true where a day name is present" do
      expect(DateTransformer.includes_day?(thurs)).to eq(true)
    end

    it "should say false where a day name is absent" do
      expect(DateTransformer.includes_day?(dec30)).to eq(false)
      expect(DateTransformer.includes_day?(online_now)).to eq(false)
    end
  end

  describe "#matching_day" do
    it "should return the matching day if there is one" do
      expect(DateTransformer.matching_day(thurs)).to eq("Thursday")
    end

    it "should return nil if there's not one" do
      expect(DateTransformer.matching_day(online_now)).to eq(nil)
      expect(DateTransformer.matching_day(dec30)).to eq(nil)
    end
  end
end
