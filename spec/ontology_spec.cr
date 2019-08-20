require "./spec_helper.cr"
require "../analyses/common_lib.cr"

go = File.open("spec/assets/specGO.json") do |gofile|
  Ontology.from_json(gofile)
end

describe "Ontology" do 
  describe "#ancestors_of" do
    it "returns all ancestors of go term" do
      go.ancestors_of("MO:4").should eq(Set{"MO:1","MO:2"})
      go.ancestors_of("MO:8").should eq(Set{"MO:1","MO:2","MO:4","MO:6"})
    end

    it "returns an empty set for obsolete terms" do
      go.ancestors_of("MO:7").should eq(Set(String).new)
    end
  end

  describe "#is_obsolete?" do
    it "returns true for obsolete terms" do
      go.is_obsolete?("MO:7").should be_true
    end

    it "returns false for non-obsolete terms" do
      go.is_obsolete?("MO:4").should be_false
      go.is_obsolete?("MO:5").should be_false
    end
  end

  describe "#main_id_of" do
    it "returns the main id of alternative go terms" do
      go.main_id_of("MO:5").should eq("MO:4")
    end
    it "returns the same id for regular go terms" do
      go.main_id_of("MO:4").should eq("MO:4")
    end
  end
end
