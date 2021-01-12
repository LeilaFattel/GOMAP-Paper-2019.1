strange_clade = GOSet.new("Sorghum_bicolor") & GOSet.new("Brachypodium_distachyon")
other_monocots = GOSet.new("Hordeum_vulgare") + 
  GOSet.new("Triticum_aestivum") + 
  GOSet.new("Oryza_sativa") + 
  GOSet.new("Zea_mays.PH207") + 
  GOSet.new("Zea_mays.B73.v4") + 
  GOSet.new("Zea_mays.Mo17") + 
  GOSet.new("Zea_mays.W22")

(strange_clade - other_monocots).output
