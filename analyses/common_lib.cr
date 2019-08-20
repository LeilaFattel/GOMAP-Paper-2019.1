require "json"

class Ontology
  JSON.mapping(
    parents: Hash(String, Array(String)),
    main_id: Hash(String, String),
    obsolete: Array(String)
  )

  def ancestors_of(go_id)
    ancestors = Set.new [] of String
    if !@parents.keys.includes? go_id
      puts "WARNING: not in Ontology: #{go_id}"
      return ancestors
    end
    @parents[go_id].each do |p|
      ancestors.add(p)
      ancestors.concat(ancestors_of(p))
    end
    return ancestors
  end

  def is_obsolete?(go_id)
    return @obsolete.includes?(go_id)
  end

  def main_id_of(go_id)
    return @main_id.keys.includes?(go_id) ? @main_id[go_id] : go_id
  end

end
