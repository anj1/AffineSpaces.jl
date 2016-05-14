# AffineSpaces.jl
This library provides a simple, general way of dealing with affine spaces, and it's implemented entirely in Julia. Affine spaces are familiar objects like points, lines, planes, etc., as well as more exotic objects like hyperplanes and so on. Using this library, you can represent and manipulate objects like this easily.

### What is it good for?
Often we want to do things like calculate plane-line intersections, or plane-plane intersections, or find the plane that passes through a line and a point, or find the distance from a point to a line in 3d, and lots of other geometric operations. There are countless Q&As on stackoverflow dealing with each of these special cases. But unforunately the code is usually very specific and not generalizable. It's also not guaranteed to work for all special cases (if planes are parallel, for example) and might be numerically unstable. For example, the intersection of three planes (in 3d) might return a point, a line, a plane, or nothing at all!

This kind of complexity and confusion is where this library comes in: You can do all these computational geometry operations and more in a way that's guaranteed to be mathematically correct. And it's all done through a unified interface - no special cases! 

### So how do I use it?

First, let's go through what an affine space is. An affine space is built upon the notion of a *vector space*. In mathematics, vector spaces can be defined in a lot of different ways, but here we're going to stick to a very simple way of defining them. We're simply going to define vector spaces as *linear combinations* of *basis vectors*. So for example, if you have a basis vector `[1,0,0]`, the vector space *generated* by this basis vector includes all vectors `a*[1,0,0]` where `a` is a real number, so it would be all vectors of the form `[a,0,0]`. If you have two basis vectors, say `[1,0,0]` (as before) and `[1/2,1,0]`, now your vector space consists of all vectors `a*[1,0,0] + b*[1/2,1,0]`, where both `a` and `b` are real numbers. So they would look like: `[a+b/2,b,0]`. In AffineSpaces.jl, we would define this vector space as follows:

```julia
VectorSpace([1 0.5
             0  1
             0  0])
```
That is, by giving the basis *matrix* as the argument to the constructor.

You can see that by manipulating basis vectors, you can generate lines (one basis vector), planes (two basis vectors), and so on.

### Affine Spaces

Affine spaces are simply vector spaces plus some offset. The vector spaces we defined had to pass through the origin - they all had to have `[0,0,0]` in the space. This puts a limitation on the kinds of lines and planes we can represent. Affine spaces don't need to pass through the origin. For example, here is the line y=1 in 2d:

```julia
# first define the vector space as the y axis (passing through the origin).
v = VectorSpace([0.0 1.0]')
# now offset it by 1.
as = AffineSpace(v,[0.0,1.0])
```

You can show that with this simple formalism, any kind of point, line, plane, hyperplane, etc. can be represented.

### Operations

In AffineSpaces.jl, there are no special cases. All affine space operations can be done between any two affine spaces. The distance between two affine spaces, for example, can be calculated easily:
```julia
dist_affine(affinespace1, affinespace2)
```

And this works no matter what the two affine spaces are or even if they are the same dimension. You can use it to calculate, for example, the distance between two points, a plane and a point, or two parallel planes. The only restriction is that the two affine spaces inhabit the same space i.e. they both inhabit 2d or 3d space. But that's it. If the two affine spaces intersect, the distance returned will simply be zero.

`generated_space` is the function that takes two affine spaces and produces the *smallest* affine space that *includes* both affine spaces. So for instance, we can calculate the line that passes through two points:
```julia
line = generated_space(point1, point2)
```

If the two points are coincident, it won't throw an error - it will just return the point.

Another example: the plane that passes through a point and a line:
```julia
plane = generated_space(line, point3)
```

Again, if the point lies on the line, it will just return the line. If `line` isn't a line, as we think, but is instead a point (for example, if it was returned from a previous operation), then it will return the line that goes through both points. In this way, in AffineSpaces.jl you don't have to worry about what your geometric objects are and you don't need to worry about writing special case code for them. Everything 'just works'.