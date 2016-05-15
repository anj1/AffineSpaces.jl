immutable VectorSpace{T,N}
	basis::Matrix{T}
end

function VectorSpace{T}(b::Array{T,2})
	VectorSpace{T,size(b,1)}(b)
end

Base.rank(v::VectorSpace) = rank(v.basis)

# orthogonal complement
ortho{T,N}(v::VectorSpace{T,N}) =
   VectorSpace{T,N}(nullspace(v.basis'))
   
# subspace union of two vector spaces
import Base.∪
∪{T,N}(v::VectorSpace{T,N},w::VectorSpace{T,N}) =
   VectorSpace{T,N}(hcat(v.basis,w.basis))

# subspace intersection of two vector spaces
import Base.∩
∩{T,N}{T,N}(v::VectorSpace{T,N},w::VectorSpace{T,N}) =
   ortho(ortho(v) ∪ ortho(w))

simplify(v::VectorSpace) = ortho(ortho(v))
