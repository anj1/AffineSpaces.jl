using FixedSizeArrays

# An affine space defined as all x satisfying Tx = b
# Here, N is the dimension of the 'parent' or 'embedding' space,
# M is the dimension of the affine space (e.g. 0 for point, 1 for line, etc.)
# and T is just the base number field.
immutable AffineSpace{T,N,M}
	T::Mat{M,N,T}   # transformation (must be part of an orthonormal transformation)
	b::Vec{M,T}     # offset
end

include("nefspaces.jl")
include("aliases.jl")
