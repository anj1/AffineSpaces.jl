# test section
# first, a simple test: y>0
hs = HalfSpace{Float64,3}([0.0, 1.0, 0.0], 0.0, true)
# And the xy plane
b = [1.0 0.0
     0.0 1.0
     0.0 0.0]
plnz = AffineSpace(VectorSpace{Float64,3}(b),[0.0,0.0,0.0])
as2 = section(hs, plnz)
@test_approx_eq as2.n [0.0,1.0]
@test_approx_eq as2.a 0.0

# now check the effect of changing the basis.
b = [2.0 0.0
     0.0 2.0
     0.0 0.0]
plnz = AffineSpace(VectorSpace{Float64,3}(b),[0.0,0.0,0.0])
as2 = section(hs, plnz)