module AffineSpaces

export AffineSpace, HalfSpace, ConvexPoly, point, section, inter, union, is_redundant, dist_affine, generated_space

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

function dist_affine{T,N}(as1::AffineSpace{T,N},as2::AffineSpace{T,N})
	v = as1.v ∪ as2.v
	C = ortho(v).basis
	norm(C*(C\(as2.x0 - as1.x0)))
end

function generated_space{T,N}(as1::AffineSpace{T,N}, as2::AffineSpace{T,N})
	v = VectorSpace{T,N}((as2.x0 - as1.x0)'')
	w = simplify(v ∪ as1.v ∪ as2.v)
	AffineSpace(w, as1.x0)
end

include("nefpoly.jl")
include("convexhull.jl")
include("voronoi.jl")

end