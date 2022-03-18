# julia-automaton
Julia scripts to create one-dimensional cellular automata.

simple.jl -- creates a very standard Wolfram-esque 1D cellular automaton. To generate a nice-looking 300x300 Rule 110 automaton, as in https://mathworld.wolfram.com/Rule110.html, import this script then run `my_automaton = automaton_gen(110, [zeros(Bool, 299); true], 300`. Note that, since julia is column-first, you'll have to get the transpose of this matrix before you visualize it.

gated.jl -- creates a cellular automaton that is gated by another automaton. When a cell is gated, it reads its neighbors as dead, and its neighbors think it is dead. `gaterule` controls which rule the gate follows, and `rule` controls the "substrate" automaton.

gated-analyze.jl -- churns through many combinations of gates and substrates. Analyzes complexity via PNG compression. This implementation may not be quite sound yet, and I recommend against taking it seriously until i figure out how to really use PNGFiles. (I'm concerned that, behind the scenes,  `PNGFiles.save()` is choosing slightly different compression schemes from file to file.)

view.jl -- view a simple or gated automaton as an image, where black pixels are dead and white pixels are alive.
