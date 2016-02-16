# A face is an affine subspace of dimension M=N-1 in
# a space of dimension N,
# along with a polygon inside this subspace.
type Facet{T,N,M}
	subspc::AffineSpace{T,N}
	ply::Poly{T,M}
end

# Note: M must be N-1 and this is checked for.

# A faceted polyhedron is a collection of faces.
type FacetedPoly{T,N,M} <: Poly{T,N}
	facets::Array{Facet{T,N,M}}
end

