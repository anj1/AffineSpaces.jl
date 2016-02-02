abstract NefSpace{T,N}

# all x where n.x + a > 0 (or >= 0 if closed=true)
immutable HalfSpace{T,N} <: NefSpace{T,N}
	n::Vec{N,T}  # normal
	a::T         # offset
	closed::Bool # is the set closed or not
end

type CompositeNefSpace{T,N} <: NefSpace{T,N}
	oper::Bool  # operation; true:intersect, false:union
	s1::NefSpace{T,N}
	s2::NefSpace{T,N}
end

function section{T,N,M}(hs::HalfSpace{T,N}, as::AffineSpace{T,N,M})
	n = convert(Matrix, as.T)
	b = convert(Vector, as.b)
	m = convert(Vector, hs.n)

	mp = hcat(nullspace(n),n') \ m
	newn = convert(Vec, mp[1:(end-M)])
	HalfSpace(newn, hs.a + dot(mp[(end-M+1):end],b), hs.closed)
end


function section(ns::CompositeNefSpace, as::AffineSpace)
	CompositeNefSpace(ns.oper,
		              intersect(ns.s1, as),
	                  intersect(ns.s2, as))
end

inter(chs1::NefSpace, chs2::NefSpace) = CompositeNefSpace(true,  chs1, chs2)
union(chs1::NefSpace, chs2::NefSpace) = CompositeNefSpace(false, chs1, chs2)

# inverting half spaces
import Base.-
-(ns::HalfSpace) = HalfSpace(-ns.n,-ns.a,~ns.closed)
-(ns::CompositeNefSpace) = CompositeNefSpace(~ns.oper, -ns.s1, -ns.s2)
