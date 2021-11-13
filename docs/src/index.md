## Presentation

The solution of many problems in dynamical systems can be seen as the fixed point of an operator. In computer-assisted proofs, the Radii Polynomial Theorem gives us closed ball(s), centred at a numerical approximation of the fixed point, within which the operator satisfies the [Banach Fixed Point Theorem](https://en.wikipedia.org/wiki/Banach_fixed-point_theorem).[^1]

[^1]: For Newton-like operators, the Radii Polynomial Theorem is an instance of the [Newton-Kantorovich Theorem](https://en.wikipedia.org/wiki/Kantorovich_theorem).

Hence, the desired solution is the unique fixed point within the ball(s) whose radius yields an a posteriori error bound on the numerical approximation.

[RadiiPolynomial.jl](https://github.com/OlivierHnt/RadiiPolynomial.jl) is a Julia package to conduct the computational steps of the Radii Polynomial Theorem which entails rigorous arithmetic (cf. [IntervalArithmetic.jl](https://github.com/JuliaIntervals/IntervalArithmetic.jl)).

When the solution lies in a Banach space involving function spaces, the standard approach is to interpret the function spaces as sequence spaces. Thus, RadiiPolynomial is concerned with the latter (cf. [ApproxFun.jl](https://github.com/JuliaApproximation/ApproxFun.jl) for a Julia package to approximate functions).

## Citing

If you use the RadiiPolynomial software in your publication, research, teaching, or other activities, please use the following BibTeX entry (cf. [`CITATION.bib`](https://github.com/OlivierHnt/RadiiPolynomial.jl/blob/main/CITATION.bib)):

```bibtex
@software{RadiiPolynomial.jl,
  author = {Olivier Hénot},
  title  = {RadiiPolynomial.jl},
  url    = {https://github.com/OlivierHnt/RadiiPolynomial.jl}
}
```