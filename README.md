# AffineSpaces.jl
This library provides a simple, general way of dealing with affine spaces, and it's implemented entirely in Julia. Affine spaces are familiar objects like points, lines, planes, etc., as well as more exotic objects like hyperplanes and so on. Using this library, you can represent and manipulate objects like this easily.

### What is it good for?
Often, in programming, we want to do things like calculate plane-line intersections, or plane-plane intersections, or find the plane that passes through a line and a point, or lots of other things. There are countless Q&As on stackoverflow dealing with each of these special cases. But unforunately the code is usually very specific and not generalizable. It's also not guaranteed to work for all special cases (if planes are parallel, for example) and might be numerically unstable. For example, the intersection of three planes (in 3d) might return a point, a line, a plane, or nothing at all!

This kind of complexity and confusion is where this library comes in: You can do all these computational geometry operations and more in a way that's guaranteed to be mathematically correct. And it's all done through a unified interface - no special cases! 

### So how do I use it?

First, let's go through what an affine space is. An affine space is built upon the notion of a *vector space*. In mathematics, vector spaces can be defined in a lot of different ways, but here we're going to stick to a very simple special case. We're simply going to define vector spaces as *linear combinations* of *basis vectors*. So for example, if you have a basis vector `[1,0,0]`, the vector space *generated* by this basis vector includes all vectors `a*[1,0,0]` where `a` is a real number, so it would be all vectors `[a,0,0]`. If you have two basis vectors, say `[1,0,0]` (as before) and `[1/2,1,0]`, now your vector space consists of all vectors `a*[1,0,0] + b*[1/2,1,0]`, where both `a` and `b` are real numbers. So they would look like: `[a+b/2,b,0]`. In AffineSpaces.jl, we would define this vector space as follows:

```julia
VectorSpace([1 0.5
             0  1
             0  0])
```
That is, by giving the basis *matrix* as the argument to the constructor.

You can see that by manipulating basis vectors, you can generate lines (one basis vector), planes (two basis vectors), and so on.

### Affine Spaces

Affine spaces are simply vector spaces plus some offset. The vector spaces we defined had to pass through the origin. Affine spaces don't need to pass through the origin. For example, here is the line y=1 in 2d:

```julia
# first define the vector space as the y axis (passing through the origin).
v = VectorSpace([0
                 1])
# now offset it by 1.
as = AffineSpace(v,[0,1])
```

### Operations

The distance between two affine spaces can be calculated easily:
```julia
dist_affine(affinespace1, affinespace2)
```

We can also calculate, for instance, the line that passes through two points:
```julia
line = generated_space(point1, point2)
```

Or the plane that passes through a point and a line:
```julia
plane = generated_space(line, point3)
```