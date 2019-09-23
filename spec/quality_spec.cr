require "./spec_helper.cr"
require "../analyses/shared/common_lib.cr"
require "../analyses/shared/quality_lib.cr"

go = File.open("spec/assets/specGO.json") do |gofile|
  Ontology.from_json(gofile)
end

# @TODO write method and test for reading something like this out of file
#predictions = [
#  ["g1","MO:3"],
#  ["g1","MO:4"],
#  ["g2","MO:8"],
#  ["g2","MO:3"],
#]
#
#gold_standard = [
#  ["g1","MO:8"],
#]

describe "hPr" do
  it "correctly calculates hierarchical precision of two sets" do
    hPr(Set{"MO:2","MO:1","MO:3"}, Set{"MO:4","MO:2","MO:1","MO:6","MO:8"}).should eq (2.0/3)
    hPr(Set{"MO:2","MO:1"}, Set{"MO:4","MO:2","MO:1","MO:6","MO:8"}).should eq 1
    hPr(Set{"MO:2","MO:1"}, Set{"MO:4"}).should eq 0
  end
end

describe "hRc" do
  it "correctly calculates hierarchical recall of two sets" do
    hRc(Set{"MO:2","MO:1","MO:3"}, Set{"MO:4","MO:2","MO:1","MO:6","MO:8"}).should eq (2.0/5)
    hRc(Set{"MO:2","MO:1"}, Set{"MO:1"}).should eq 1
    hRc(Set{"MO:2","MO:1"}, Set{"MO:4"}).should eq 0
  end
end

describe "Verspoor_modified" do

  predictions = {
    "g1" => [Set{"MO:2", "MO:1", "MO:3"}, Set{"MO:2", "MO:1", "MO:4"}], 
    "g2" => [Set{"MO:4", "MO:2", "MO:1", "MO:6", "MO:8"}, Set{"MO:2", "MO:1", "MO:3"}]
  }
  gold_standard = {
    "g1" => [Set{"MO:4", "MO:2", "MO:1", "MO:6", "MO:8"}]
  }

  describe "mean_hPr" do
    it "correctly calculates mean hPr for two annotation sets" do
      Verspoor_modified.mean_hPr(predictions, gold_standard).should be_close(0.41666666, 0.0001) 
    end
  end
  describe "mean_hRc" do
    it "correctly calculates mean hRc for two annotation sets" do
      Verspoor_modified.mean_hRc(predictions, gold_standard).should eq 0.5 
    end
  end
end
