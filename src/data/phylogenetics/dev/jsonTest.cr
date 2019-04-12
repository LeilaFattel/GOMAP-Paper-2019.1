require "json"

class SlimOntology
  JSON.mapping(
    parents: Hash(String, Array(String))
  )


  def ancestors_of(go_id)
    ancestors = Set.new [] of String

    @parents[go_id].each do |p|
      ancestors.add(p)
      ancestors.concat(ancestors_of(p))
    end

    return ancestors
  end

end

a = SlimOntology.from_json(File.open("slimGO.json"))
puts a.ancestors_of("GO:1990413")
