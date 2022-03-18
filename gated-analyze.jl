include("gated.jl")

using PNGFiles

function analyze(autorules, gaterules, stateone, steps)
	firstgate = minimum(gaterules)
	firstrule = minimum(autorules)
	buf = IOBuffer()
	filesizes = Matrix{Int64}(undef, length(autorules), length(gaterules))
	for a in autorules
		for g in gaterules
			println("gate: ",g,", automaton: ",a)
			automaton = gated_gen(a, stateone, steps, g)
			PNGFiles.save(buf, transpose(automaton))
			filesizes[a - firstrule + 1, g - firstgate + 1] = length(take!(buf))
		end
	end
	return(filesizes)
end
