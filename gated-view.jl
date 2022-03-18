include("gated.jl")

# a simple way to view these automata as images

steps = 400
startingvec = [zeros(Bool,399); true]
simpleautomaton = automaton_gen(110, startingvec, steps)
gatedautomaton = gated_gen(110, startingvec, steps, 22)

using Images, ImageView

imshow(transpose(simpleautomaton)) # because julia is column-first, we have to transpose
				   # these automata to view them in the standard way
imshow(transpose(gatedautomaton))
