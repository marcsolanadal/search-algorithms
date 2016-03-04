require './kqueens'
require './min_conflicts'
require 'benchmark'

N = 6

csp = KQueens.new(N)
mc = MinConflicts.new(csp, 1000)

Benchmark.bmbm do |x|
  x.report("MC #{N}:") { mc.solve }
end

puts ""
puts "----------------------------------"
puts "SOLUTION:"
puts "----------------------------------"
csp.to_s
puts "----------------------------------"
