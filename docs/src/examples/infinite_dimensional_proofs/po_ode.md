# Periodic orbit for ordinary differential equations (ODE)

In this example, we will prove the existence of a periodic orbit of the Lorenz equations

```math
\frac{d}{dt} u(t) = f(u(t), \sigma, \rho, \beta) :=
\begin{pmatrix}
\sigma(u_2(t) - u_1(t))\\
u_1(t)(\rho - u_3(t)) - u_2(t)\\
u_1(t) u_2(t) - \beta u_3(t)
\end{pmatrix}.
```

Let ``\nu > 1`` and ``X_\textnormal{F} := (\ell^1_\nu, *)`` where

```math
\ell^1_\nu := \left\{ u \in \mathbb{C}^\mathbb{Z} \, : \, |u|_{\ell^1_\nu} := \sum_{k \in \mathbb{Z}} |u_k| \nu^{|k|} \right\}
```

and ``* : \ell^1_\nu \times \ell^1_\nu \to \ell^1_\nu`` is the discrete convolution given by

```math
u * v := \left\{ \sum_{l \in \mathbb{Z}} u_{k - l} v_l \right\}_{k \in \mathbb{Z}}, \qquad \text{for all } u, v \in \ell^1_\nu.
```

For any sequence ``u \in X``, the Fourier series ``\sum_{k \in \mathbb{Z}} u_k e^{i \omega k t}``, for some frequency ``\omega > 0``, defines an analytic ``2\pi\omega^{-1}``-periodic function in ``C^\omega(\mathbb{R}, \mathbb{C})``; while the discrete convolution ``*`` corresponds to the product of Fourier series in sequence space.

The Banach algebra ``X_\textnormal{F}`` is a suitable space to look for a periodic solution of the Lorenz equations. Indeed, it is a standard result from ODE theory that analytic vector fields yield analytic solutions.[^1]

[^1]: A. Hungria, J.-P. Lessard and J. D. Mireles James, [Rigorous numerics for analytic solutions of differential equations: the radii polynomial approach](https://doi.org/10.1090/mcom/3046), *Mathematics of Computation*, **85** (2016), 1427-1459.

Define the Banach space ``X := \mathbb{C} \times X_\textnormal{F}^3`` endowed with the norm ``|x|_X := \max(|\gamma|, |u_1|_{X_\textnormal{F}}, |u_2|_{X_\textnormal{F}}, |u_3|_{X_\textnormal{F}})``. It follows that the sequence of coefficients of a ``2\pi\gamma``-periodic Fourier series solving the Lorenz equations is a zero of the mapping ``F : X \to X`` given by

```math
F(x) :=
\begin{pmatrix}
\sum_{j = 1}^3 (\sum_{k = -n}^n (u_j)_k - \xi_j)\eta_j\\
\left\{ \gamma ( f(u, \sigma, \rho, \beta) )_k - i k u_k \right\}_{k \in \mathbb{Z}}
\end{pmatrix}, \qquad \text{for all } x := (\gamma, u_1, u_2, u_3) \in X,
```

where ``\xi \in \mathbb{R}^3`` is a chosen approximate position on the periodic orbit and ``\eta \in \mathbb{R}^3`` the corresponding approximate tangent vector at ``\xi``. By means of the *phase condition* ``\sum_{j = 1}^3 (\sum_{k = -n}^n (u_j)_k - \xi_j)\eta_j``, the translation invariance of the periodic orbit is eliminated.

Consider the fixed-point operator ``T : X \to X`` defined by

```math
T(x) := x - A F(x),
```

where ``A : X \to X`` is the injective operator corresponding to a numerical approximation of ``DF(\bar{x})^{-1}`` for some numerical zero ``\bar{x} := (\bar{\gamma}, \bar{u}_1, \bar{u}_2, \bar{u}_3) \in X`` of ``F``.

Let ``R > 0``. Since ``T \in C^2(X, X)`` we may use the [second-order Radii Polynomial Theorem with ``C^2`` condition](@ref C2_condition_RPT) such that we need to estimate ``|T(\bar{x}) - \bar{x}|_X``, ``|DT(\bar{x})|_{\mathscr{B}(X, X)}`` and ``\sup_{x \in \text{cl}( B_R(\bar{x}) )} |D^2T(x)|_{\mathscr{B}(X^2, X)}``.

To this end, consider the truncation operator

```math
(\pi^n u)_k :=
\begin{cases}
u_k, & |k| \leq n,\\
0, & |k| > n,
\end{cases}
\qquad \textnormal{for all } u \in X_\textnormal{F}.
```

Using the same symbol, this projection extends naturally to ``X_\textnormal{F}^3`` and ``X`` by acting on each component as follows ``\pi^n u := (\pi^n u_1, \pi^n u_2, \pi^n u_3)``, for all ``u := (u_1, u_2, u_3) \in X_\textnormal{F}^3``, and ``\pi^n x := (\gamma, \pi^n u_1, \pi^n u_2, \pi^n u_3)``, for all ``x := (\gamma, u_1, u_2, u_3) \in X``. For each of the Banach spaces ``X_\textnormal{F}, X_\textnormal{F}^3, X``, we define the complementary operator ``\pi^{\infty(n)} := I - \pi^n``.

Thus, denoting ``\bar{u} := (\bar{u}_1, \bar{u}_2, \bar{u}_3)``, we have

```math
\begin{aligned}
|T(\bar{x}) - \bar{x}|_X &\leq
|\pi^n A \pi^n F(\bar{x})|_X + \frac{\bar{\gamma}}{n+1} | \pi^{\infty(n)} f(\bar{u}) |_{X_\textnormal{F}^3},\\
|DT(\bar{x})|_{\mathscr{B}(X, X)} &\leq
|\pi^n A \pi^n DF(\bar{x}) \pi^{2n} - \pi^n|_{\mathscr{B}(X, X)} + \frac{1}{n+1} | \pi^{\infty(n)} f(\bar{u}) |_{X_\textnormal{F}^3} +\\
&\qquad \frac{\bar{\gamma}}{n+1}
\max \left(2 \sigma, 1 + |\bar{u}_1|_{X_\textnormal{F}} + |\rho - \bar{u}_3|_{X_\textnormal{F}}, \beta + |\bar{u}_1|_{X_\textnormal{F}} + |\bar{u}_2|_{X_\textnormal{F}}\right),\\
\sup_{x \in \text{cl}( B_R(\bar{x}) )} |D^2T(x)|_{\mathscr{B}(X^2, X)} &\leq
2\left(|\pi^n A \pi^n|_{\mathscr{B}(X, X)} + \frac{1}{n+1}\right) \Big(\bar{\gamma} + R +\\
&\qquad \max \left(2 \sigma, 1 + \rho + |\bar{u}_1|_{X_\textnormal{F}} + |\bar{u}_3|_{X_\textnormal{F}} + 2R, \beta + |\bar{u}_1|_{X_\textnormal{F}} + |\bar{u}_2|_{X_\textnormal{F}} + 2R\right)\Big).
\end{aligned}
```

We can now write our computer-assisted proof:

```@example
using RadiiPolynomial

function f!(f::Sequence, u::Sequence, σ, ρ, β)
    u₁, u₂, u₃ = component(u, 1), component(u, 2), component(u, 3)
    project!(component(f, 1), σ*(u₂ - u₁))
    project!(component(f, 2), u₁*(ρ - u₃) - u₂)
    project!(component(f, 3), u₁*u₂ - β*u₃)
    return f
end

function Df!(Df::LinearOperator, u::Sequence, σ, ρ, β)
    u₁, u₂, u₃ = component(u, 1), component(u, 2), component(u, 3)
    project!(component(Df, 1, 1), Multiplication(-σ*one(u₁)))
    project!(component(Df, 1, 2), Multiplication(σ*one(u₂)))
    project!(component(Df, 1, 3), Multiplication(zero(u₃)))
    project!(component(Df, 2, 1), Multiplication(ρ-u₃))
    project!(component(Df, 2, 2), Multiplication(-one(u₂)))
    project!(component(Df, 2, 3), Multiplication(-u₁))
    project!(component(Df, 3, 1), Multiplication(u₂))
    project!(component(Df, 3, 2), Multiplication(u₁))
    project!(component(Df, 3, 3), Multiplication(-β*one(u₃)))
    return Df
end

function F_DF!(F, DF, x, σ, ρ, β)
    γ, u = x[1], component(x, 2)
    DF .= zero(eltype(DF))

    F[1] =
        (sum(view(component(u, 1), :)) - 10.205222700615433) * 24.600655549587863 +
        (sum(view(component(u, 2), :)) - 11.899530531689562) * (-2.4927169722923335) +
        (sum(view(component(u, 3), :)) - 27.000586375896557) * 71.81142025024573
    component(component(DF, 1, 2), 1)[1,:] .= 24.600655549587863
    component(component(DF, 1, 2), 2)[1,:] .= -2.4927169722923335
    component(component(DF, 1, 2), 3)[1,:] .= 71.81142025024573

    f!(component(F, 2), u, σ, ρ, β) .*= γ
    rsub!(component(F, 2), differentiate(u))
    D₁F₂ = component(DF, 2, 1)
    f!(Sequence(codomain(D₁F₂), vec(coefficients(D₁F₂))), u, σ, ρ, β)
    Df!(component(DF, 2, 2), u, σ, ρ, β) .*= γ
    rsub!(component(DF, 2, 2), project(Derivative(1), domain(component(DF, 2, 2)), codomain(component(DF, 2, 2)), eltype(DF)))

    return F, DF
end

# numerical solution

σ, ρ, β = 10.0, 28.0, 8/3

n = 400

x̄ = Sequence(ParameterSpace() × Fourier(n, 1.0)^3, zeros(ComplexF64, 1+3*(2n+1)))
x̄[1] = 9.150971830259179/2π # approximate inverse of the frequency
component(component(x̄, 2), 1)[0:14] =
    [6.25, -0.66 - 1.45im, 0.6 - 1.2im, 1.11 - 0.26im, 0.77 + 0.57im,
    0.08 + 0.76im, -0.35 + 0.45im, -0.39 + 0.13im, -0.37 - 0.0008im, -0.44 - 0.23im,
    -0.18 - 0.68im, 0.65 - 0.61im, 0.80 + 0.50im, -0.53 + 0.43im, 1.25 - 0.07im]
component(component(x̄, 2), 2)[0:14] =
    [6.25, -0.56 - 1.5im, 0.76 - 1.12im, 1.17 - 0.03im, 0.62 + 0.78im,
    -0.18 + 0.76im,-0.54 + 0.3im, -0.45 - 0.06im, -0.37 - 0.2im, -0.3 - 0.51im,
    0.29 - 0.8im, 1.11 - 0.13im, 0.4 + 1.16im, -0.91 - 0.05im, 1.31 + 1.13im]
component(component(x̄, 2), 3)[0:14] =
    [24.45, -0.22 - 1.62im, 1.13 - 0.83im, 1.2 + 0.53im, 0.14 + 1.28im,
    -1.03 + 0.75im, -1.14 - 0.52im, -0.08 - 1.21im, 0.98 - 0.57im, 0.79 + 0.59im,
    -0.27 + 0.69im, -0.34 - 0.23im, 0.57 + 0.22im, -1.23 + 1.02im, 0.75 - 2.69im]
view(component(component(x̄, 2), 1), -14:-1) .= conj.(reverse(view(component(component(x̄, 2), 1), 1:14)))
view(component(component(x̄, 2), 2), -14:-1) .= conj.(reverse(view(component(component(x̄, 2), 2), 1:14)))
view(component(component(x̄, 2), 3), -14:-1) .= conj.(reverse(view(component(component(x̄, 2), 3), 1:14)))

x̄, success = newton!((F, DF, x) -> F_DF!(F, DF, x, σ, ρ, β), x̄; verbose = false)
x̄[1] = real(x̄[1])
for i ∈ 1:3
    component(component(x̄, 2), i)[0] = real(component(component(x̄, 2), i)[0])
    view(component(component(x̄, 2), i), -n:-1) .= conj.(view(component(component(x̄, 2), i), n:-1:1))
end

# proof

σ_interval, ρ_interval, β_interval = Interval(10.0), Interval(28.0), @interval(8/3)
x̄_interval = Sequence(ParameterSpace() × Fourier(n, Interval(1.0))^3, Interval.(coefficients(x̄)))
γ̄_interval = real(x̄_interval[1])
ū_interval = component(x̄_interval, 2)
F_interval = Sequence(ParameterSpace() × Fourier(2n, Interval(1.0))^3, similar(coefficients(x̄_interval), 1+3*(4n+1)))
DF_interval = LinearOperator(space(F_interval), space(x̄_interval), similar(coefficients(x̄_interval), length(x̄_interval), length(F_interval)))
F_DF!(F_interval, DF_interval, x̄_interval, σ_interval, ρ_interval, β_interval)
tail_f_interval = zero(component(F_interval, 2))
for i ∈ 1:3
    view(component(tail_f_interval, i), n+1:2n) .= view(component(component(F_interval, 2), i), n+1:2n)
    view(component(tail_f_interval, i), -2n:-n-1) .= view(component(component(F_interval, 2), i), -2n:-n-1)
end
A = Interval.(inv(mid.(project(DF_interval, space(x̄_interval), space(x̄_interval)))))
bound_tail_A = inv(Interval(n+1))

ν = Interval(1.01)
X_Fourier = ℓ¹(GeometricWeight(ν))
X_Fourier³ = NormedCartesianSpace(X_Fourier, ℓ∞())
X = NormedCartesianSpace((ℓ∞(), X_Fourier³), ℓ∞())
R = 1e-8

Y = norm(A*F_interval, X) + bound_tail_A * γ̄_interval * norm(tail_f_interval, X_Fourier³)
Z₁ = opnorm(A*DF_interval - I, X) + bound_tail_A * norm(tail_f_interval, X_Fourier³) +
    bound_tail_A * γ̄_interval * max(2σ_interval,
        1 + norm(component(ū_interval, 1), X_Fourier) + norm(ρ_interval-component(ū_interval, 3), X_Fourier),
        β_interval + norm(component(ū_interval, 1), X_Fourier) + norm(component(ū_interval, 2), X_Fourier))
Z₂ = (opnorm(A, X) + bound_tail_A) * 2 * (γ̄_interval + R +
    max(2σ_interval,
        1 + ρ_interval + norm(component(ū_interval, 1), X_Fourier) + norm(component(ū_interval, 3), X_Fourier) + 2R,
        β_interval + norm(component(ū_interval, 1), X_Fourier) + norm(component(ū_interval, 2), X_Fourier) + 2R))
showfull(interval_of_existence(Y, Z₁, Z₂, R, C²Condition()))
```

The following figure[^2] shows the numerical approximation of the proven periodic orbit (blue line) and the equilibria (red markers).

[^2]: S. Danisch and J. Krumbiegel, [Makie.jl: Flexible high-performance data visualization for Julia](https://doi.org/10.21105/joss.03349), *Journal of Open Source Software*, **6** (2021), 3349.

```@raw html
<video width="800" height="400" controls autoplay loop>
  <source src="../../../assets/lorenz.mp4" type="video/mp4">
</video>
```
