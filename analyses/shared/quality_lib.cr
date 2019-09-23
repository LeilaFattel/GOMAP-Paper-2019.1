# hPr and hRc: Calculate hierarchical precision/recall of two sets.
# Pass a set of annotation as the first argument, the set of gold standard
# anntoations as the second argument.
# Returns hPr or hRc value.
def hPr(pred, gs)
  return (pred & gs).size.to_f / pred.size
end
def hRc(pred, gs)
  return (pred & gs).size.to_f / gs.size
end

# Extend Array class with arithmetic mean function. 
# Attention: Only use for arrays that exclusively contain numbers!
class Array
  def mean
    (self.reduce(0) {|s,x| s+x}).to_f/self.size
  end
end

# This is hPr and hRc as used in our previous paper (http://dx.doi.org/10.1002/pld3.52)
module Verspoor_modified
  def self.mean_hPr(p_set, gs_set)
    gene_averages = p_set.map do |gene, annotations|
      if gs_set.has_key? gene
        annotation_averages = annotations.map do |p_annotation|
          combinations = gs_set[gene].map do |gs_annotation|
            hPr(p_annotation, gs_annotation)
          end
          combinations.mean
        end
        annotation_averages.mean
      else
        0
      end
    end
    return gene_averages.mean
  end

  def self.mean_hRc(p_set, gs_set)
    gene_averages = gs_set.map do |gene, annotations|
      if p_set.has_key? gene
        annotation_averages = annotations.map do |gs_annotation|
          combinations = p_set[gene].map do |p_annotation|
            hRc(p_annotation, gs_annotation)
          end
          combinations.mean
        end
        annotation_averages.mean
      else
        0
      end
    end
    return gene_averages.mean
  end
end
