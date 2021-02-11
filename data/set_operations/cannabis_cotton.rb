cannabis = GOSet.new("Cannabis_sativa")
cotton   = GOSet.new("Gossypium_raimondii")
shared_among_legumes = GOSet.new("Phaseolus_vulgaris") &
  GOSet.new("Vigna_unguiculata") &
  GOSet.new("Glycine_max") &
  GOSet.new("Medicago_truncatula.A17") &
  GOSet.new("Medicago_truncatula.R108") &
  GOSet.new("Arachis_hypogaea")
merged_legumes = GOSet.new("Phaseolus_vulgaris") +
  GOSet.new("Vigna_unguiculata") +
  GOSet.new("Glycine_max") +
  GOSet.new("Medicago_truncatula.A17") +
  GOSet.new("Medicago_truncatula.R108") +
  GOSet.new("Arachis_hypogaea")

puts("What do all legumes AND cotton have in common that cannabis doesn't have?")
((shared_among_legumes & cotton) - cannabis).output

puts("\n"*5)
puts("What does cannabis have that's not found in any of the legumes?")
(cannabis - merged_legumes).output
