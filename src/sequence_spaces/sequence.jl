"""
    Sequence{T<:VectorSpace,S<:AbstractVector}

Compactly supported sequence of the given space.

Fields:
- `space :: T`
- `coefficients :: S`
"""
struct Sequence{T<:VectorSpace,S<:AbstractVector}
    space :: T
    coefficients :: S
    function Sequence{T,S}(space::T, coefficients::S) where {T<:VectorSpace,S<:AbstractVector}
        d = dimension(space)
        l = length(coefficients)
        d == l || return throw(DimensionMismatch("dimensions must match: space has dimension $d, coefficients has length $l"))
        return new{T,S}(space, coefficients)
    end
end

Sequence(space::T, coefficients::S) where {T<:VectorSpace,S<:AbstractVector} =
    Sequence{T,S}(space, coefficients)

space(a::Sequence) = a.space

coefficients(a::Sequence) = a.coefficients

# order, frequency

order(a::Sequence) = order(space(a))
order(a::Sequence, i::Int) = order(space(a), i)

frequency(a::Sequence) = frequency(space(a))
frequency(a::Sequence, i::Int) = frequency(space(a), i)

# utilities

Base.firstindex(a::Sequence) = _firstindex(space(a))

Base.lastindex(a::Sequence) = _lastindex(space(a))

Base.length(a::Sequence) = length(coefficients(a))

Base.size(a::Sequence) = size(coefficients(a)) # necessary for broadcasting

Base.iterate(a::Sequence) = iterate(coefficients(a))
Base.iterate(a::Sequence, i) = iterate(coefficients(a), i)

Base.eltype(a::Sequence) = eltype(coefficients(a))
Base.eltype(::Type{Sequence{T,S}}) where {T,S} = eltype(S)

# getindex, view, setindex!

Base.@propagate_inbounds Base.getindex(a::Sequence, α) =
    getindex(coefficients(a), _findposition(α, space(a)))
Base.@propagate_inbounds Base.getindex(a::Sequence, u::AbstractRange) =
    getindex(coefficients(a), _findposition(u, space(a)))
Base.@propagate_inbounds function Base.getindex(a::Sequence, u::AbstractVector)
    v = Vector{eltype(a)}(undef, length(u))
    for (i, uᵢ) ∈ enumerate(u)
        v[i] = a[uᵢ]
    end
    return v
end
Base.@propagate_inbounds Base.getindex(a::Sequence{TensorSpace{T}}, α::NTuple{N,Int}) where {N,T<:NTuple{N,BaseSpace}} =
    getindex(coefficients(a), _findposition(α, space(a)))
Base.@propagate_inbounds Base.getindex(a::Sequence{TensorSpace{T}}, u::NTuple{N,Any}) where {N,T<:NTuple{N,BaseSpace}} =
    getindex(a, TensorIndices(map(_colon2indices, u, spaces(space(a)))))
Base.@propagate_inbounds function Base.getindex(a::Sequence{TensorSpace{T}}, u::TensorIndices{<:NTuple{N,Any}}) where {N,T<:NTuple{N,BaseSpace}}
    v = Vector{eltype(a)}(undef, length(u))
    for (i, uᵢ) ∈ enumerate(u)
        v[i] = a[uᵢ]
    end
    return v
end

Base.@propagate_inbounds Base.view(a::Sequence, α) =
    view(coefficients(a), _findposition(α, space(a)))

Base.@propagate_inbounds Base.setindex!(a::Sequence, x, α) =
    setindex!(coefficients(a), x, _findposition(α, space(a)))
Base.@propagate_inbounds Base.setindex!(a::Sequence, x, u::AbstractRange) =
    setindex!(coefficients(a), x, _findposition(u, space(a)))
Base.@propagate_inbounds function Base.setindex!(a::Sequence, x, u::AbstractVector)
    for (i, uᵢ) ∈ enumerate(u)
        a[uᵢ] = x[i]
    end
    return x
end
Base.@propagate_inbounds Base.setindex!(a::Sequence{TensorSpace{T}}, x, α::NTuple{N,Int}) where {N,T<:NTuple{N,BaseSpace}} =
    setindex!(coefficients(a), x, _findposition(α, space(a)))
Base.@propagate_inbounds Base.setindex!(a::Sequence{TensorSpace{T}}, x, u::NTuple{N,Any}) where {N,T<:NTuple{N,BaseSpace}} =
    setindex!(a, x, TensorIndices(map(_colon2indices, u, spaces(space(a)))))
Base.@propagate_inbounds function Base.setindex!(a::Sequence{TensorSpace{T}}, x, u::TensorIndices{<:NTuple{N,Any}}) where {N,T<:NTuple{N,BaseSpace}}
    for (i, uᵢ) ∈ enumerate(u)
        a[uᵢ] = x[i]
    end
    return x
end

# ==, iszero, isapprox

Base.:(==)(a::Sequence, b::Sequence) =
    space(a) == space(b) && coefficients(a) == coefficients(b)

Base.iszero(a::Sequence) = iszero(coefficients(a))

Base.isapprox(a::Sequence, b::Sequence; kwargs...) =
    space(a) == space(b) && isapprox(coefficients(a), coefficients(b); kwargs...)

# copy, similiar

Base.copy(a::Sequence) = Sequence(space(a), copy(coefficients(a)))

Base.similar(a::Sequence) = Sequence(space(a), similar(coefficients(a)))
Base.similar(a::Sequence, ::Type{T}) where {T} = Sequence(space(a), similar(coefficients(a), T))

# zero

function Base.zero(a::Sequence)
    space_a = space(a)
    CoefType = eltype(a)
    c = Sequence(space_a, Vector{CoefType}(undef, dimension(space_a)))
    coefficients(c) .= zero(CoefType)
    return c
end

# float, complex, real, imag, conj, conj!

for f ∈ (:float, :complex, :real, :imag, :conj, :conj!)
    @eval Base.$f(a::Sequence) = Sequence(space(a), $f(coefficients(a)))
end

# promotion

Base.convert(::Type{T}, a::T) where {T<:Sequence} = a
Base.convert(::Type{Sequence{T₁,S₁}}, a::Sequence{T₂,S₂}) where {T₁,S₁,T₂,S₂} =
    Sequence{T₁,S₁}(convert(T₁, space(a)), convert(S₁, coefficients(a)))

Base.promote_rule(::Type{T}, ::Type{T}) where {T<:Sequence} = T
Base.promote_rule(::Type{Sequence{T₁,S₁}}, ::Type{Sequence{T₂,S₂}}) where {T₁,S₁,T₂,S₂} =
    Sequence{promote_type(T₁, T₂), promote_type(S₁, S₂)}

# Parameter space

# one

Base.one(a::Sequence{ParameterSpace}) = Sequence(space(a), [one(eltype(a))])

# Sequence spaces

# one

function Base.one(a::Sequence{<:SequenceSpace})
    c = zero(a)
    @inbounds c[_findindex_constant(space(a))] = one(eltype(a))
    return c
end

# selectdim

Base.@propagate_inbounds function Base.selectdim(a::Sequence{<:TensorSpace}, dim::Int, i)
    A = _no_alloc_reshape(coefficients(a), dimensions(space(a)))
    return selectdim(A, dim, _findposition(i, spaces(space(a))[dim]))
end

# permutedims

Base.permutedims(a::Sequence{<:TensorSpace}, σ::AbstractVector{Int}) =
    Sequence(space(a)[σ], vec(permutedims(_no_alloc_reshape(coefficients(a), dimensions(space(a))), σ)))

# Cartesian spaces

eachcomponent(a::Sequence{<:CartesianSpace}) =
    (@inbounds(component(a, i)) for i ∈ Base.OneTo(nb_cartesian_product(space(a))))

Base.@propagate_inbounds component(a::Sequence{<:CartesianSpace}, i) =
    Sequence(space(a)[i], view(coefficients(a), _component_findposition(i, space(a))))

# show

function Base.show(io::IO, ::MIME"text/plain", a::Sequence)
    println(io,
        "Sequence in " * string_space(space(a)) *
        " with coefficients " * string(typeof(coefficients(a))) * ":"
        )
    Base.print_array(io, coefficients(a))
end
