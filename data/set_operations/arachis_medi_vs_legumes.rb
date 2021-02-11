arachis_medi = GOSet.new("Arachis_hypogaea") & (GOSet.new("Medicago_truncatula.A17") + GOSet.new("Medicago_truncatula.R108"))
legumes = GOSet.new("Glycine_max") + 
  GOSet.new("Phaseolus_vulgaris") + 
  GOSet.new("Vigna_unguiculata")

(arachis_medi - legumes).output
