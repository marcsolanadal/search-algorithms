ruby-prof --mode=wall --printer=dot --file=output.dot main.rb 25
dot -T pdf -o output.pdf output.dot 
acroread output.pdf 

