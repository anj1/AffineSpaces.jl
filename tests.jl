using AffineSpaces
using Base.Test 

# distance between two points
# Our equation is Ax=a;
# a point x_0 would be given by I*x = x_0
x1 = randn(4)
x2 = randn(4)
pt1 = AffineSpace(eye(4),x1)
pt2 = AffineSpace(eye(4),x2)
@test_approx_eq dist_affine(pt1, pt2) sqrt(dot(x1-x2,x1-x2))

# distance between point and line in 2D
# We can have a line y = x;
# represented as ([-1, 1]')*[x, y] = 0
ln = AffineSpace([-1.0, 1.0]',[0.0])
# and a point [1, 0].
pt = AffineSpace(eye(2),[1.0,0.0])
# The distance should be sqrt(2)/2
@test_approx_eq dist_affine(ln, pt) (sqrt(2)/2)

# distance between point and line in 3D
# let's have a line [x,y]=[0,0]
# and a point [x,y,z]=[1,0,0]
# The distance should be 1
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
ln = AffineSpace(A, zeros(2))
pt = AffineSpace(eye(3),[1.0,0.0,0.0])
@test_approx_eq dist_affine(ln, pt) 1.0

# distance between line and plane incident on it  
# (should be zero)
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
ln  = AffineSpace(A, zeros(2))
pln = AffineSpace([0.0,0.0,1.0]',[2.0])
@test_approx_eq dist_affine(ln, pln) 0.0

# TODO:
# preset spaces line Point, Line, Plane, etc.
# that initialize AffineSpace

# generate three points randomly on xy plane
# and construct common space (should be xy plane itself)
pt1 = AffineSpace(eye(3),vcat(randn(2),[0.0]))
pt2 = AffineSpace(eye(3),vcat(randn(2),[0.0]))
pt3 = AffineSpace(eye(3),vcat(randn(2),[0.0]))
pln = generated_space(generated_space(pt1,pt2),pt3)
@test_approx_eq pln.L Vec([0.0,0.0,1.0])
@test_approx_eq pln.b Vec([0.0])

println("All tests passed.")