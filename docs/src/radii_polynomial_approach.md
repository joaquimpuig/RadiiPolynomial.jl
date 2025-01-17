# [Radii polynomial approach](@id radii_polynomial_approach)

Let ``X`` be a Banach space, ``U`` an open subset of ``X``, ``T : U \to X`` an operator, ``x_0 \in U`` and ``R > 0`` such that ``\text{cl}( B_R(x_0) ) \subset U``.

## [First-order Radii Polynomial Theorem](@id first_order_RPT)

Suppose ``T \in C^1(U, X)`` and ``Y, Z_1 \geq 0`` satisfy

```math
\begin{aligned}
|T(x_0) - x_0|_X &\leq Y,\\
\sup_{x \in \text{cl}( B_R(x_0) )} |DT(x)|_{\mathscr{B}(X, X)} &\leq Z_1,
\end{aligned}
```

and define the *radii polynomial* by

```math
p(r) := Y + (Z_1 - 1) r.
```

If there exists a *radius* ``r_0 \in [0, R]`` such that

```math
p(r_0) \leq 0 \qquad \text{and} \qquad Z_1 < 1,
```

then ``T`` has a unique fixed point in ``\text{cl}( B_{r_0} (x_0) )``.

## Second-order Radii Polynomial Theorem

### ``C^1`` condition

Suppose ``T \in C^1(U, X)`` and ``Y, Z_1, Z_2 \geq 0`` satisfy

```math
\begin{aligned}
|T(x_0) - x_0|_X &\leq Y,\\
|DT(x_0)|_{\mathscr{B}(X, X)} &\leq Z_1,\\
|DT(x) - DT(x_0)|_{\mathscr{B}(X, X)} &\leq Z_2 |x - x_0|, \qquad \text{for all } x \in \text{cl}( B_R(x_0) ),
\end{aligned}
```

and define the *radii polynomial* by

```math
p(r) := Y + (Z_1 - 1) r + \frac{Z_2}{2} r^2.
```

If there exists a *radius* ``r_0 \in [0, R]`` such that

```math
p(r_0) \leq 0 \qquad \text{and} \qquad Z_1 + Z_2 r_0 < 1,
```

then ``T`` has a unique fixed point in ``\text{cl}( B_{r_0} (x_0) )``.

### [``C^2`` condition](@id C2_condition_RPT)

Suppose ``T \in C^2(U, X)`` and ``Y, Z_1, Z_2 \geq 0`` satisfy

```math
\begin{aligned}
|T(x_0) - x_0|_X &\leq Y,\\
|DT(x_0)|_{\mathscr{B}(X, X)} &\leq Z_1,\\
\sup_{x \in \text{cl}( B_R(x_0) )} |D^2T(x)|_{\mathscr{B}(X^2, X)} &\leq Z_2,
\end{aligned}
```

and define the *radii polynomial* by

```math
p(r) := Y + (Z_1 - 1) r + \frac{Z_2}{2} r^2.
```

If there exists a *radius* ``r_0 \in [0, R]`` such that

```math
p(r_0) \leq 0 \qquad \text{and} \qquad Z_2 r_0 < 1,
```

then ``T`` has a unique fixed point in ``\text{cl}( B_{r_0} (x_0) )``.

## Interval of existence

The set of all possible radii is called the *interval of existence*.

The infimum of the interval of existence gives the sharpest computed a posteriori error bound on ``x_0``. The supremum of the interval of existence represents the largest computed radius of the ball centred at ``x_0`` within which the solution is unique.

The `interval_of_existence` method returns an `Interval` such that ``p`` is negative.

```@docs
interval_of_existence(Y::Interval{T}, Z₁::Interval{T}, R::T) where {T<:Real}
interval_of_existence(Y::Interval{T}, Z₁::Interval{T}, Z₂::Interval{T}, R::T, ::C¹Condition) where {T<:Real}
interval_of_existence(Y::Interval{T}, Z₁::Interval{T}, Z₂::Interval{T}, R::T, ::C²Condition) where {T<:Real}
```
