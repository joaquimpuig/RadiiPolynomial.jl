# Special operators

## Projection

```@repl
using RadiiPolynomial
A = LinearOperator(Taylor(1) ⊗ Chebyshev(1), Taylor(1) ⊗ Chebyshev(1), [1.0 0.0 0.0 0.0 ; 0.0 1.0 0.0 0.0 ; 0.0 0.0 1.0 0.0 ; 0.0 0.0 0.0 1.0])
project(A, Taylor(1) ⊗ Chebyshev(2), Taylor(2) ⊗ Chebyshev(1), Float64)
```

## Multiplication

```@repl
using RadiiPolynomial
A = Multiplication(Sequence(Taylor(1) ⊗ Fourier(1, 1.0), [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]))
project(A, Taylor(1) ⊗ Fourier(1, 1.0), Taylor(2) ⊗ Fourier(0, 1.0), Float64)
```

## Derivation and integration

```@repl
using RadiiPolynomial
project(Derivative(1), Taylor(2), Taylor(1), Float64)
project(Derivative((1, 1)), Taylor(2) ⊗ Fourier(1, 1.0), Taylor(1) ⊗ Fourier(1, 1.0), Complex{Float64})
```

```@repl
using RadiiPolynomial
project(Integral(1), Taylor(2), Taylor(3), Float64)
project(Integral((1, 1)), Taylor(1) ⊗ Fourier(1, 1.0), Taylor(2) ⊗ Fourier(1, 1.0), Complex{Float64})
```

## Evaluation

```@repl
using RadiiPolynomial
project(Evaluation(0.5), Taylor(2), Taylor(0), Float64)
project(Evaluation((0.5, nothing)), Taylor(2) ⊗ Fourier(1, 1.0), Taylor(0) ⊗ Fourier(1, 1.0), Float64)
```

## Scale

```@repl
using RadiiPolynomial
project(Scale(2.0), Taylor(2), Taylor(2), Float64)
project(Scale((2.0, nothing)), Taylor(2) ⊗ Fourier(1, 1.0), Taylor(2) ⊗ Fourier(1, 1.0), Float64)
```

## Shift

```@repl
using RadiiPolynomial
project(Shift(π/2), Fourier(1, 1.0), Fourier(1, 1.0), Complex{Float64})
```
