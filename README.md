# AffineSpaces.jl
This library provides a simple, general way of dealing with affine subspaces, and it's implemented entirely in Julia. Affine subspaces are familiar objects like points, lines, planes, etc., as well as more exotic objects like hyperplanes and so on. Using this library, you can represent and manipulate objects like this easily.

### What is it good for?
Often we want to do things like calculate plane-line intersections, or plane-plane intersections, or find the plane that passes through a line and a point, or find the distance from a point to a line in 3d, and lots of other geometric operations. There are countless Q&As on stackoverflow dealing with each of these special cases. But unforunately the code is usually very specific and not generalizable. It's also not guaranteed to work for all special cases (if planes are parallel, for example) and might be numerically unstable. For example, the intersection of three planes (in 3d) might return a point, a line, a plane, or nothing at all, and our code needs to be able to reflect this.

This kind of complexity and confusion is where this library comes in: You can do all these computational geometry operations and more in a way that's guaranteed to be mathematically correct. And it's all done through a unified interface - no special cases.

### So how do I use it?

First, let's go through what an affine subspace is. An affine subspace is built upon the notion of a *vector space*. In mathematics, vector spaces can be defined in a lot of different ways, but here we're going to stick to a very simple way of defining them. We're simply going to define vector spaces as *linear combinations* of *basis vectors*. So for example, if you have a basis vector `[1,0,0]`, the vector space *generated* by this basis vector includes all vectors `a*[1,0,0]` where `a` is a real number, so it would be all vectors of the form `[a,0,0]`. If you have two basis vectors, say `[1,0,0]` (as before) and `[1/2,1,0]`, now your vector space consists of all vectors `a*[1,0,0] + b*[1/2,1,0]`, where both `a` and `b` are real numbers. So they would look like: `[a+b/2,b,0]`. In AffineSpaces.jl, we would define this vector space as follows:

```julia
VectorSpace([1 0.5
             0  1
             0  0])
```
That is, by giving the basis *matrix* as the argument to the constructor.

You can see that by manipulating basis vectors, you can generate lines (one basis vector), planes (two basis vectors), and so on.

### Affine Subspaces

Affine subspaces are simply vector spaces plus some offset. The vector spaces we defined had to pass through the origin - they all had to have `[0,0,0]` in the space. This puts a limitation on the kinds of lines and planes we can represent. Affine subspaces don't need to pass through the origin. For example, here is the line y=1 in 2d:

```julia
# first define the vector space as the y axis (passing through the origin).
v = VectorSpace([1.0 0.0]')
# now offset it by 1.
as = AffineSpace(v,[0.0,1.0])
```

You can show that with this simple formalism, any kind of point, line, plane, hyperplane, etc. can be represented.

### Operations
#### Distance

In AffineSpaces.jl, all affine subspace operations can be done between any two affine spaces. The distance between two affine spaces, for example, can be calculated easily:
```julia
dist_affine(affinesubspace1, affinesubspace2)
```

And this works no matter what the two affine subspaces are. You can use it to calculate, for example, the distance between two points, a plane and a point, or two parallel planes. The only restriction is that the two subspaces inhabit the same space i.e. they both inhabit 2d or 3d space. But that's it. If the two affine subspaces intersect, the distance returned will simply be zero.

The fact that this function is so general is even more interesting when you look at the implementation of the function:

```julia
function dist_affine{T,N}(as1::AffineSpace{T,N},as2::AffineSpace{T,N})
	v = as1.v ∪ as2.v
	C = ortho(v).basis
	norm(C*(C\(as2.x0 - as1.x0)))
end
ortho{T,N}(v::VectorSpace{T,N}) =
    VectorSpace{T,N}(nullspace(v.basis'))
```
This is the power of working with a general affine subspace structure - very general calculations can be performed in a simple way.

#### Generated subspaces
`generated_space` is the function that takes two affine subspaces and produces the *smallest* affine subspace that *includes* both. So for instance, we can calculate the line that passes through two points:
```julia
line = generated_space(point1, point2)
```

If the two points are coincident, it won't throw an error - it will just return the point, as it should.

Another example: the plane that passes through a point and a line:
```julia
plane = generated_space(line, point3)
```

Again, if the point lies on the line, it will just return the line. If `line` isn't a line, as we think, but is instead a point (for example, if it was returned from a previous operation), then it will return the line that goes through both points. In this way, in AffineSpaces.jl you don't have to worry about what your geometric objects are and you don't need to worry about writing special case code for them. Everything 'just works'.

#### Intersections

The following function can be used to calculate affine subspace intersections. The intersection is the largest affine subspace that is included in both.

```julia
intersect(affinesubspace1, affinesubspace2)
```
### Solid Geometry
AffineSpaces.jl contains a set of functions for performing *solid geometry* - the geometry of volumes including n-dimensional polyhedra. These are described below.

#### Half-spaces
The simplest volume is the entire R<sup>n</sup> space. We can represent this space using basis vectors, as mentioned. However, R<sup>n</sup> by itself is not that interesting. It becomes more interesting when we introduce the notion of *half-spaces*. Half-spaces are produced when we take an n-dimensional space and divide it into parts using a *hyperplane* (an affine subspace of dimension n-1). For example, we can divide the 2D plane into two parts with a line, or a 3D space into two parts with a plane. Mathematically, we can represent a half-space of dimension n as follows. Let **a** be a normal vector of dimension n, and *b* be a real number. Then all points **x** in the space that satisfy:

**a**<sup>T</sup>**x** > b

Or, if it's a *closed* half-space:

**a**<sup>T</sup>**x** ≥ b

Together form a half-space. To create a half-space in AffineSpaces.jl, we simply input **a** and *b*, for example here's a 3D half-space:

```julia
hs = HalfSpace{Float64,3}([0.0,1.0,1.0],5.0,true)
```

The first parameter is the normal vector, the second parameter is the offset, and the final parameter specifies if the half-space is closed or not.


#### Convex polyhedra

Now that we have a notion of half-spaces, we can combine them together via *intersections*, using the function `inter()`. Half-spaces are convex spaces. The intersection of any two convex spaces is also a convex space, so the intersection of any number of half-spaces is also a convex space. Indeed, you can show that *any* convex space/polyhedron can be formed via an intersection of half-spaces. This idea forms the basis of [Nef polyhedron theory](https://en.wikipedia.org/wiki/Nef_polygon), and gives us a simple mathematical formalism for dealing with convex polyhedra.

In addition, if you take an affine subspace of dimension *m* < *n*, and compute its intersection with a convex space of dimension *n*, you get a convex space of dimension *m*. This is very useful for, for example, computing ray-polyhedron intersections for various rendering/physics simulations. In AffineSpaces.jl, the function that performs this intersection is:

```julia
section(halfspace, affinesubspace)
```

AffineSpaces.jl provides the functions 

There are many more functions in AffineSpaces.jl. Look at test/ and src/ for the various functions that are available.
