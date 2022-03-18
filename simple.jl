function bitvals(m, nbits=Int8(8))
	# returns the nbits (up to 127) least significant bits of m in an 8-element boolean vector
	bitlist = zeros(Bool,nbits)
	for i in Int8(nbits):Int8(-1):Int8(1) # range backwards from nbits to 1)
		if m ⊻ 1 == m - 1 # if m ends in 1, so flipping the last bit subtracts 1
			bitlist[i] = true
		end
		m >>= 1
	end
	return(bitlist)
end

function wolfram(n)
	# returns the three-cell chunks that yield live cells in the next generation
	# n is a wolfram rule number (0 to 255)
	steps = 0x01:0x08
	rule_vec = bitvals(n)
	birthstates = Vector{Bool}[]
	for i in steps
		if rule_vec[i]
			wstate = bitvals(Int8(8)-Int8(i), 0x03) 
			# in wolfram's paper, parent states are sorted by their values as 3-digit
			# binary numbers. so 111, 110¸ 101, etc. i=1 --> left-most state is
			# [1,1,1] --> add the state bitvals(8-1) = bitvals(7) = [true, true, true]
			push!(birthstates,wstate)
		end
	end
	return(birthstates) # looks like [[true, true, false], [false, false, false], ...]
end

function automaton_gen(rule::Integer, stateone::Vector{Bool}, steps::Integer)
	# rule is a wolfram rule to follow
	# stateone is the starting state of the automaton
	# steps is self-explanatory, hopefully
	birthstates = wolfram(rule)
	width = length(stateone)
	states = zeros(Bool,width,steps) # a matrix of falses -- could make this undef actually
	states[1:width] = stateone

	for i in 2:steps
		laststate = Bool[0; states[1:width,i-1]; 0]
		Threads.@threads for j in 2:(width+1) # @threads allows parallelization
			states[j-1,i] = in(birthstates).([laststate[j-1:j+1]])[1]
		end
		#states[1:width,i]=state
	end
	return(states)
end
