using AffineSpaces.jl

# distance between two points
# Our equation is Ax=a;
# a point x_0 would be given by I*x = x_0
x1 = randn(4)
x2 = randn(4)
@show sqrt(dot(x1-x2,x1-x2))
@show dist_affine(eye(4),x1,eye(4),x2)

# distance between point and line in 2D
# We can have a line y = x;
# represented as ([-1, 1]')*[x, y] = 0
A = [-1.0, 1.0]'
# and a point [1, 0].
# The distance should be sqrt(2)/2
@show dist_affine(A,[0.0],eye(2),[1,0])

# distance between point and line in 3D
# let's have a line [x,y]=[0,0]
# and a point [x,y,z]=[1,0,0]
# The distance should be 1
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
@show dist_affine(A,zeros(2),eye(3),[1.0,0.0,0.0])

# distance between line and plane incident on it  
# (should be zero)
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
@show dist_affine(A,zeros(2),[0.0,0.0,1.0]',[2])

# TODO:
# preset spaces line Point, Line, Plane, etc.
# that initialize AffineSpace
