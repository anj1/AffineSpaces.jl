# some useful abstractions and special cases.

# n-dimensional point.
typealias Point{T,N} AffineSpace{T,N,N}
Point{T,N}(x0::Vec{N,T}) = AffineSpace(Mat(eye(N)), x0)

# line in 2 dimensions, given by starting point and vector
function Line2D{T}(p0::Point{T,2}, v::Vec{2,T})
  fv = Vec([v[2],-v[1]])
  AffineSpace(Mat(v0)', dot(p0,v0))
end
