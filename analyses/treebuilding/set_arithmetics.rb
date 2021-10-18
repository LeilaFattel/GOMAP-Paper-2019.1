require "set"
require "json"

class GOSet < Set
  def initialize(species_name = nil)
    if species_name
      super(load_species(species_name))
    else
      super()
    end
    @go_names = JSON.parse(File.read("analyses/cleanup/results/GO_names.json"))
  end

  def load_species(species_name)
    JSON.parse(File.read("analyses/treebuilding/results/sets/with_ancestors/#{species_name}.json")).map(&:to_sym).to_set
  end

  def output(print_name = true)
    self.each do |t|
      if @go_names.key?(t.to_s) and print_name
        puts("#{t} - #{@go_names[t.to_s]}")
      else
        puts(t)
      end
    end
  end

end

require "./"+ARGV.first
