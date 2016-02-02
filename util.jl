# distance between two affine spaces
# due to Gross & Trenkler, and DuPre & Kass (1992)
function dist_affine{T,N}(as1::AffineSpace{T,N},as2::AffineSpace{T,N})
	A,a = as1.T,as1.b
	B,b = as2.T,as2.b
  
	C = nullspace(hcat(nullspace(B),nullspace(A))')
	ortho_proj = C*pinv(C)
	norm(ortho_proj*(pinv(A)*a - pinv(B)*b))
end

# signed distance between a half-space and a point
signed_distance{T,N}(hs::HalfSpace{T,N}, p::Point{T,N}) = dot(hs.n, p.b) + hs.a
