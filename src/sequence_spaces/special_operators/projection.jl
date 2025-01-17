# fallback methods

function project(a::Sequence, space_dest::VectorSpace, ::Type{T}=eltype(a)) where {T}
    _iscompatible(space(a), space_dest) || return throw(DimensionMismatch)
    c = Sequence(space_dest, Vector{T}(undef, dimension(space_dest)))
    _project!(c, a)
    return c
end

function project!(c::Sequence, a::Sequence)
    _iscompatible(space(a), space(c)) || return throw(DimensionMismatch)
    _project!(c, a)
    return c
end

function _project!(c::Sequence, a::Sequence)
    space_a = space(a)
    space_c = space(c)
    if space_a == space_c
        coefficients(c) .= coefficients(a)
    elseif space_c ⊆ space_a
        @inbounds for α ∈ indices(space_c)
            c[α] = a[α]
        end
    else
        coefficients(c) .= zero(eltype(c))
        @inbounds for α ∈ indices(space_a ∩ space_c)
            c[α] = a[α]
        end
    end
    return c
end

#

function project(A::LinearOperator, domain_dest::VectorSpace, codomain_dest::VectorSpace, ::Type{T}=eltype(A)) where {T}
    _iscompatible(domain(A), domain_dest) & _iscompatible(codomain(A), codomain_dest) || return throw(DimensionMismatch)
    C = LinearOperator(domain_dest, codomain_dest, Matrix{T}(undef, dimension(codomain_dest), dimension(domain_dest)))
    _project!(C, A)
    return C
end

function project!(C::LinearOperator, A::LinearOperator)
    _iscompatible(domain(A), domain(C)) & _iscompatible(codomain(A), codomain(C)) || return throw(DimensionMismatch)
    _project!(C, A)
    return C
end

function _project!(C::LinearOperator, A::LinearOperator)
    domain_A, codomain_A = domain(A), codomain(A)
    domain_C, codomain_C = domain(C), codomain(C)
    if domain_A == domain_C && codomain_A == codomain_C
        coefficients(C) .= coefficients(A)
    elseif domain_C ⊆ domain_A && codomain_C ⊆ codomain_A
        @inbounds for β ∈ indices(domain_C), α ∈ indices(codomain_C)
            C[α,β] = A[α,β]
        end
    else
        coefficients(C) .= zero(eltype(A))
        @inbounds for β ∈ indices(domain_A ∩ domain_C), α ∈ indices(codomain_A ∩ codomain_C)
            C[α,β] = A[α,β]
        end
    end
    return C
end

# Cartesian spaces

function _project!(c::Sequence{<:CartesianSpace}, a::Sequence{<:CartesianSpace})
    space_c = space(c)
    if space(a) == space_c
        coefficients(c) .= coefficients(a)
    else
        @inbounds for i ∈ 1:nb_cartesian_product(space_c)
            _project!(component(c, i), component(a, i))
        end
    end
    return c
end

#

function _project!(C::LinearOperator{<:CartesianSpace,<:CartesianSpace}, A::LinearOperator{<:CartesianSpace,<:CartesianSpace})
    domain_C = domain(C)
    codomain_C = codomain(C)
    if domain(A) == domain_C && codomain(A) == codomain_C
        coefficients(C) .= coefficients(A)
    else
        @inbounds for j ∈ 1:nb_cartesian_product(domain_C), i ∈ 1:nb_cartesian_product(codomain_C)
            _project!(component(C, i, j), component(A, i, j))
        end
    end
    return C
end

function _project!(C::LinearOperator{<:CartesianSpace,<:VectorSpace}, A::LinearOperator{<:CartesianSpace,<:VectorSpace})
    domain_C = domain(C)
    if domain(A) == domain_C && codomain(A) == codomain(C)
        coefficients(C) .= coefficients(A)
    else
        @inbounds for j ∈ 1:nb_cartesian_product(domain_C)
            _project!(component(C, j), component(A, j))
        end
    end
    return C
end

function _project!(C::LinearOperator{<:VectorSpace,<:CartesianSpace}, A::LinearOperator{<:VectorSpace,<:CartesianSpace})
    codomain_C = codomain(C)
    if domain(A) == domain(C) && codomain(A) == codomain_C
        coefficients(C) .= coefficients(A)
    else
        @inbounds for i ∈ 1:nb_cartesian_product(codomain_C)
            _project!(component(C, i), component(A, i))
        end
    end
    return C
end
