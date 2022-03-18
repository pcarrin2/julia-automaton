include("simple.jl")
function gated_gen(rule::Integer, stateone::Vector{Bool}, steps::Integer, gaterule::Integer)
	# rule is a wolfram rule
	# stateone is the starting state of the automaton
	# steps is self-explanatory, number of steps to run
	# gaterule is the wolfram rule number of this automaton's gate
	gates = automaton_gen(gaterule,stateone,steps)
	birthstates = wolfram(rule)
	width = length(stateone)
	states = zeros(Bool,width,steps)
	states[1:width] = stateone

	for i in 2:steps
		laststate = Bool[0; states[1:width,i-1]; 0]
		lastgates = Bool[0; gates[1:width,i-1]; 0]
		for j in 2:(width+1)
			chunk = Vector{Bool}(undef,3)
			if lastgates[j]
				chunk = Bool[0, laststate[j], 0]
			else
				chunk[1] = (!lastgates[j-1])&laststate[j-1]
				chunk[2] = laststate[j]
				chunk[3] = (!lastgates[j+1])&laststate[j+1]
			end
			states[j-1,i] = in(birthstates).([chunk])[1]
		end
	end
	return(states)
end
