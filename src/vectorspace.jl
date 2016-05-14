immutable VectorSpace{T,N}
	basis::Matrix{T}
	VectorSpace{T,N}(b::Array{T,N}) = new{T,N}(b)
end

Base.rank(v::VectorSpace) = rank(v.basis)

# subspace union of two vector spaces
import Base.∪
∪{T,N}(v::VectorSpace{T,N},w::VectorSpace{T,N}) =
   VectorSpace{T,N}(hcat(v.basis,w.basis))

# orthogonal complement
ortho{T,N}(v::VectorSpace{T,N}) =
   VectorSpace{T,N}(nullspace(v.basis'))

simplify(v::VectorSpace) = ortho(ortho(v))
