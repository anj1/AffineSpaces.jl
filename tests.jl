using AffineSpaces
using FixedSizeArrays
using Base.Test 

# distance between two points
# Our equation is Ax=a;
# a point x_0 would be given by I*x = x_0
x1 = randn(4)
x2 = randn(4)
pt1 = point(x1)
pt2 = point(x2)
@test_approx_eq dist_affine(pt1, pt2) sqrt(dot(x1-x2,x1-x2))

# distance between point and line in 2D
# We can have a line y = x;
# represented as ([-1, 1]')*[x, y] = 0
ln = AffineSpace([-1.0, 1.0]',[0.0])
# and a point [1, 0].
pt = point([1.0,0.0])
# The distance should be sqrt(2)/2
@test_approx_eq dist_affine(ln, pt) (sqrt(2)/2)

# distance between point and line in 3D
# let's have a line [x,y]=[0,0]
# and a point [x,y,z]=[1,0,0]
# The distance should be 1
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
ln = AffineSpace(A, zeros(2))
pt = point([1.0,0.0,0.0])
@test_approx_eq dist_affine(ln, pt) 1.0

# distance between line and plane incident on it  
# (should be zero)
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
ln  = AffineSpace(A, zeros(2))
pln = AffineSpace([0.0,0.0,1.0]',[2.0])
@test_approx_eq dist_affine(ln, pln) 0.0

# TODO:
# preset spaces line point, Line, Plane, etc.
# that initialize AffineSpace

# generate three points randomly on xy plane
# and construct common space (should be xy plane itself)
pt1 = point(vcat(randn(2),[0.0]))
pt2 = point(vcat(randn(2),[0.0]))
pt3 = point(vcat(randn(2),[0.0]))
pln = generated_space(generated_space(pt1,pt2),pt3)
plnz = AffineSpace([0.0,0.0,1.0]',[0.0])
@test_approx_eq pln.v.basis plnz.v.basis
@assert abs(dist_affine(pln, plnz)) < 1e-15

# construct plane that passes through a line in 3d
# and a point in 3d
A = [1.0 0.0 0.0
     0.0 1.0 0.0]
ln = AffineSpace(A, zeros(2))  # [x,y]=[0,0]
pt = point([1.0,1.0,0.0]) # x=y=1
pln = generated_space(pt, ln) # plane x=y
plnxy = AffineSpace([1.0,-1.0,0.0]',[0.0])
@test_approx_eq pln.v.basis plnxy.v.basis
@assert abs(dist_affine(pln, plnxy)) < 1e-15

# confirm that two parallel planes create the same plane
# NOTE: this test is now redundant
# pln1 = AffineSpace([1.0,0.5,2.0]',[3.0])
# pln2 = AffineSpace([2.0,1.0,4.0]',[6.0])
# pln3 = generated_space(pln1, pln2)
# @assert size(pln3.L)==(1,3)

# TODO: right now there is the problem that 0xN Mats
# aren't supported.
# confirm that three random points in 2d generate plane
pt1 = point(vcat(randn(2)))
pt2 = point(vcat(randn(2)))
pt3 = point(vcat(randn(2)))
pln = generated_space(generated_space(pt1,pt2),pt3)
@assert rank(pln)==2

# check is_redundant for unit square
hs1 = HalfSpace{Float64,2}([ 1.0,  0.0],  0.0, true)
hs2 = HalfSpace{Float64,2}([-1.0,  0.0], -1.0, true)
hs3 = HalfSpace{Float64,2}([ 0.0,  1.0],  0.0, true)
hs4 = HalfSpace{Float64,2}([ 0.0, -1.0], -1.0, true)
hs5 = HalfSpace{Float64,2}([-1.0,  0.0], -2.0, true)
c1 = ConvexPoly([hs1,hs2,hs3])
@assert is_redundant(c1, hs4)==false
c2 = ConvexPoly([hs1,hs2,hs3,hs4])
@assert is_redundant(c2, hs5)==true


# test 'section'
# first, a simple test: y>0.5 -> 2y>1
hs = HalfSpace{Float64,3}([0.0, 1.0, 0.0], 1.0, true)
# And the xy plane
b = [1.0 0.0
     0.0 2.0
     0.0 0.0]
plnz = AffineSpace(VectorSpace{Float64,3}(b),[0.0,0.0,0.0])
as2 = section(hs, plnz)
@test_approx_eq as2.n [0.0,2.0]
@test_approx_eq as2.a 1.0

println("All tests passed.")