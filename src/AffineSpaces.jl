module AffineSpaces

export AffineSpace, VectorSpace, HalfSpace, ConvexPoly, point, section, inter, union, is_redundant, dist_affine, generated_space

include("vectorspace.jl")

# An affine space defined as:
# {x + x0 | x in V}
immutable AffineSpace{T,N}
	v::VectorSpace{T,N}
	x0::Vector{T}  # offset
end

Base.rank(as::AffineSpace) = rank(as.v)

# generate affine space from equation:
# Lx=a
AffineSpace{T}(L::Matrix{T},a::Vector{T}) =
   AffineSpace(VectorSpace{T,size(L,2)}(nullspace(L)),pinv(L)*a)

point{T}(x0::Vector{T}) =
   AffineSpace(VectorSpace{T,length(x0)}(Array(T,length(x0),0)),x0)

# Distance between two affine spaces.
# Spaces need not be of same rank i.e. distance between point and line
# is perfectly fine.
function dist_affine{T,N}(as1::AffineSpace{T,N},as2::AffineSpace{T,N})
	v = as1.v ∪ as2.v
	C = ortho(v).basis
	norm(C*(C\(as2.x0 - as1.x0)))
end

# Smallest affine space that includes both as1 and as2 as affine subspaces.
function generated_space{T,N}(as1::AffineSpace{T,N}, as2::AffineSpace{T,N})
	v = VectorSpace{T,N}(reshape(as2.x0 - as1.x0,(N,1)))
	w = simplify(v ∪ as1.v ∪ as2.v)
	AffineSpace(w, as1.x0)
end

# An abstract representation of a polyhedron in the N-dimensional
# space with underlying number field T
abstract Poly{T,N}

include("nefpoly.jl")
end