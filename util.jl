#vec_space_union(V,W)   = nullspace(hcat(nullspace(V),nullspace(W))')
#vec_space_union(V,W,U) = nullspace(hcat(nullspace(V),nullspace(W),nullspace(U))')

# vector from a point in Ax=a to a point in Bx=b
spanning_vec(A,a,B,b) = (A\a) - (B\b)

# distance between two affine spaces
# due to Gross & Trenkler, and DuPre & Kass (1992)
function dist_affine{T,N}(as1::AffineSpace{T,N},as2::AffineSpace{T,N})
	A,a = convert(Array,as1.L),convert(Vector,as1.b)
	B,b = convert(Array,as2.L),convert(Vector,as2.b)
  
	C = nullspace(hcat(nullspace(B),nullspace(A))')
	ortho_proj = C*pinv(C)
	norm(ortho_proj*spanning_vec(A,a,B,b))
end

# signed distance between a half-space and a point
signed_distance{T,N}(hs::HalfSpace{T,N}, p::Point{T,N}) = dot(hs.n, p.b) + hs.a

# find space of least dimension that includes both as1 and as2 as subspaces
function generated_space{T,N}(as1::AffineSpace{T,N}, as2::AffineSpace{T,N})
	A,a = convert(Array,as1.L),convert(Vector,as1.b)
	B,b = convert(Array,as2.L),convert(Vector,as2.b)

	v = spanning_vec(A,a,B,b)
	# combine together v and the solution spaces for Ax=0 and Bx=0
	C = nullspace(hcat(nullspace(A),nullspace(B),v)')
	AffineSpace(C', C\(A\a))   # calculate proper offset
end