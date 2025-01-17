# Initial value problem for ordinary differential equations (ODE)

In this example, we will prove the existence of a solution of the initial value problem

```math
\begin{cases}
\displaystyle \frac{d}{dt} u(t) = f(u(t)) := u(t)^2 - u(t),\\
u(0) = 1/2.
\end{cases}
```

Let ``\nu > 0`` and ``X := (\ell^1_\nu, *)`` where

```math
\ell^1_\nu := \left\{ \{ x_\alpha \}_{\alpha \geq 0} \in \mathbb{R}^{\mathbb{N} \cup \{0\}} \, : \, | x |_{\ell^1_\nu} := \sum_{\alpha \geq 0} |x_\alpha| \nu^\alpha < +\infty \right\}
```

and ``* : \ell^1_\nu \times \ell^1_\nu \to \ell^1_\nu`` is the Cauchy product given by

```math
x * y := \left\{ \sum_{\beta = 0}^\alpha x_{\alpha - \beta} y_\beta \right\}_{\alpha \geq 0}, \qquad \text{for all } x, y \in \ell^1_\nu.
```

For any sequence ``x \in X``, the Taylor series ``\sum_{\alpha \geq 0} x_\alpha t^\alpha`` defines an analytic function in ``C^\omega([-\nu, \nu], \mathbb{R})``; while the Cauchy product ``*`` corresponds to the product of Taylor series in sequence space.

The Banach algebra ``X`` is a suitable space to look for a solution of the initial value problem. Indeed, it is a standard result from ODE theory that analytic vector fields yield analytic solutions.[^1]

[^1]: A. Hungria, J.-P. Lessard and J. D. Mireles James, [Rigorous numerics for analytic solutions of differential equations: the radii polynomial approach](https://doi.org/10.1090/mcom/3046), *Mathematics of Computation*, **85** (2016), 1427-1459.

It follows that the sequence of coefficients of a Taylor series solving the initial value problem is a zero of the mapping ``F : X \to X`` given component-wise by

```math
( F(x) )_\alpha :=
\begin{cases}
x_0 - 1/2, & \alpha = 0,\\
\alpha x_\alpha - (x*x - x)_{\alpha-1}, & \alpha \geq 1.
\end{cases}
```

Consider the fixed-point operator ``T : X \to X`` defined by

```math
T(x) := x - A F(x),
```

where ``A : X \to X`` is the injective operator corresponding to a numerical approximation of ``DF(\bar{x})^{-1}`` for some numerical zero ``\bar{x} \in X`` of ``F``.

Let ``R > 0``. Since ``T \in C^2(X, X)`` we may use the [second-order Radii Polynomial Theorem with ``C^2`` condition](@ref C2_condition_RPT) such that we need to estimate ``|T(\bar{x}) - \bar{x}|_X``, ``|DT(\bar{x})|_{\mathscr{B}(X, X)}`` and ``\sup_{x \in \text{cl}( B_R(\bar{x}) )} |D^2T(x)|_{\mathscr{B}(X^2, X)}``.

To this end, consider the truncation operator

```math
(\pi^n x)_\alpha :=
\begin{cases} x_\alpha, & \alpha \leq n,\\
0, & \alpha > n,
\end{cases} \qquad \text{for all } x \in X,
```

as well as the complementary operator ``\pi^{\infty(n)} := I - \pi^n``.

Thus, we have

```math
\begin{aligned}
|T(\bar{x}) - \bar{x}|_X &\leq |\pi^n A \pi^n F(\bar{x})|_X + \frac{1}{n+1} |\pi^{\infty(n)} F(\bar{x})|_X,\\
|DT(\bar{x})|_{\mathscr{B}(X, X)} &\leq |\pi^n A \pi^n DF(\bar{x}) \pi^n - \pi^n|_{\mathscr{B}(X, X)} + \frac{\nu}{n+1} |2\bar{x} - 1|_X,\\
\sup_{x \in \text{cl}( B_R(\bar{x}) )} |D^2T(x)|_{\mathscr{B}(X^2, X)} &\leq 2 \nu \left( |\pi^n A \pi^n|_{\mathscr{B}(X, X)} + \frac{1}{n+1} \right).
\end{aligned}
```

In particular, from the latter estimate, we may freely choose ``R = \infty``.

We can now write our computer-assisted proof:

```@example
using RadiiPolynomial

function F(x::Sequence{Taylor})
    f = x^2 - x
    F_ = Sequence(Taylor(order(f)+1), Vector{eltype(x)}(undef, length(f)+1))
    F_[0] = x[0] - 0.5
    F_[1:end] .= Derivative(1) * x - f
    return F_
end

function DF(x::Sequence{Taylor}, domain::Taylor, codomain::Taylor, ::Type{CoefType}) where {CoefType}
    DF_ = LinearOperator(domain, codomain, zeros(CoefType, dimension(codomain), dimension(domain)))
    DF_[0,0] = one(CoefType)
    DF_[1:end,:] .=
        project(Derivative(1), domain, Taylor(order(codomain)-1), CoefType) .-
        project(Multiplication(2x - 1), domain, Taylor(order(codomain)-1), CoefType)
    return DF_
end

# numerical solution

n = 27
x̄ = Sequence(Taylor(n), zeros(n+1))
x̄, success = newton(x -> (project(F(x), space(x)), DF(x, space(x), space(x), eltype(x))),
    x̄;
    verbose = false)

# proof

x̄_interval = Interval.(x̄)
F_interval = F(x̄_interval)
tail_F_interval = copy(F_interval)
tail_F_interval[0:n] .= Interval(0.0)
DF_interval = DF(x̄_interval, space(x̄_interval), space(x̄_interval), eltype(x̄_interval))
A = inv(mid.(DF_interval))
bound_tail_A = inv(Interval(n+1))

ν = Interval(2.0)
X = ℓ¹(GeometricWeight(ν))
R = Inf

Y = norm(A * F_interval, X) + bound_tail_A * norm(tail_F_interval, X)
Z₁ = opnorm(A * DF_interval - I, X) + bound_tail_A * ν * norm(2x̄_interval - 1, X)
Z₂ = 2ν * (opnorm(A, X) + bound_tail_A)
showfull(interval_of_existence(Y, Z₁, Z₂, R, C²Condition()))
```

The following figure[^2] shows the numerical approximation of the proven solution in the interval ``[-2, 2]`` along with the theoretical solution ``t \mapsto (e^{t} + 1)^{-1}``.

[^2]: S. Danisch and J. Krumbiegel, [Makie.jl: Flexible high-performance data visualization for Julia](https://doi.org/10.21105/joss.03349), *Journal of Open Source Software*, **6** (2021), 3349.

![](../../assets/ivp.svg)
