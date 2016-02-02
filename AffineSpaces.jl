using FixedSizeArrays

# An affine space defined as all x satisfying Tx = b
immutable AffineSpace{T,N,M}
	T::Mat{M,N,T}   # transformation (must be part of an orthonormal transformation)
	b::Vec{M,T}     # offset
end

include("nefspaces.jl")
include("aliases.jl")
