# This script reads a gzipped GAF file and prints the rows to the screen.

require "csv"
require "gzip"

Gzip::Reader.open(ARGF) do |gzfile|
  csv = CSV.new(gzfile, separator:'\t')

  # Skip the two header lines
  csv.next
  csv.next

  while csv.next
    puts csv.row.to_a
  end
end
