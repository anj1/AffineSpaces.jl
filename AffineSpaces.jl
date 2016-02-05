module AffineSpaces

using FixedSizeArrays

export AffineSpace, HalfSpace, Point, Line2D, section, inter, union, dist_affine, generated_space

# An affine space defined as all x satisfying Tx = b
# Here, N is the dimension of the 'parent' or 'embedding' space,
# M is the number of 'free' dimensions of the affine space
#  (e.g. N for point, N-1 for line, 1 for hyperplane, etc.)
# and T is just the base number field.
immutable AffineSpace{T,N,M}
	L::Mat{M,N,T}   # transformation (must be part of an orthonormal transformation)
	b::Vec{M,T}     # offset
end

AffineSpace(L::Array,b::Vector) = AffineSpace(Mat(L),Vec(b))

include("nefspaces.jl")
include("aliases.jl")
include("util.jl")

end