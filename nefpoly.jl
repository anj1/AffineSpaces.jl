using Convex, SCS
set_default_solver(SCSSolver(verbose=0))

abstract NefPoly{T,N}

# all x where n.x > a (or >= a if closed=true)
immutable HalfSpace{T,N} <: NefPoly{T,N}
	n::Vec{N,T}  # normal
	a::T         # offset
	closed::Bool # is the set closed or not
end
HalfSpace(n::Vector,a,c) = HalfSpace(Vec(n),a,c)


# A convex space is an intersection of a set of half-spaces,
# and is a kind of Nef space.
type ConvexPoly{T,N} <: NefPoly{T,N}
	hs::Vector{HalfSpace{T,N}}
end

# A Nef space can be a complicated logical expression
# tree involving half spaces.
type CompositeNefPoly{T,N} <: NefPoly{T,N}
	oper::Bool  # operation; true:intersect, false:union
	s1::NefPoly{T,N}
	s2::NefPoly{T,N}
end

function section{T,N,M}(hs::HalfSpace{T,N}, as::AffineSpace{T,N,M})
	n = convert(Matrix, as.L)
	b = convert(Vector, as.b)
	m = convert(Vector, hs.n)

	mp = hcat(nullspace(n),n') \ m
	newn = convert(Vec, mp[1:(end-M)])
	HalfSpace(newn, dot(mp[(end-M+1):end],b) - hs.a, hs.closed)
end


function section(ply::CompositeNefPoly, as::AffineSpace)
	CompositeNefPoly(ply.oper,
	                 intersect(ply.s1, as),
	                 intersect(ply.s2, as))
end

section(ply::ConvexPoly, as::AffineSpace) = ConvexPoly([hs -> section(hs, as) for hs in ply.hs])

import Base.union
inter(ply1::NefPoly, ply2::NefPoly) = CompositeNefPoly(true,  ply1, ply2)
union(ply1::NefPoly, ply2::NefPoly) = CompositeNefPoly(false, ply1, ply2)

# inverting half spaces
import Base.-
-(ns::HalfSpace) = HalfSpace(-ns.n,-ns.a,~ns.closed)
-(ply::CompositeNefPoly) = CompositeNefPoly(~ply.oper, -ply.s1, -ply.s2)
# - for ConvexPoly does not return a convex space.

# check if a particular half-space is redundant
function is_redundant{T,N}(ply::ConvexPoly{T,N},h::HalfSpace{T,N})
	# construct transformation matrix
	A = Array(T,length(ply.hs),N)
	a = Array(T,length(ply.hs))
	for i = 1 : length(ply.hs)
		A[i,:] = convert(Array,ply.hs[i].n)
		a[i] = ply.hs[i].a
	end
	# solve linear program
	x = Variable(N)
	nrml = convert(Array, h.n)'
	prblm = minimize(nrml*x - h.a, [A*x > a])
	solve!(prblm)
	# decide whether half-space is redundant or not
	if (prblm.solution.optval < 0.0) ||
	   (prblm.solution.status == :Unbounded)
		return false
	else
		return true
	end 
end