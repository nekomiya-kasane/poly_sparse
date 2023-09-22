#############################################################################
#############################################################################
#
# This file implements polynomial addition 
#                                                                               
#############################################################################
#############################################################################

import Base: +
import Base: getindex

function Base.getindex(l::MutableLinkedList, idx::Int128)
    Base.getindex(l, Int(idx))
end

"""
Add a polynomial and a term.
"""
function +(p::PolynomialSparse128, t::Term)
    p = deepcopy(p)
    if t.degree > degree(p)
        push!(p, t)
    else
        if !iszero(p.terms[t.degree + 1]) #+1 is due to indexing
            p.terms[t.degree + 1] += t
        else
            p.terms[t.degree + 1] = t
        end
    end

    return trim!(p)
end
+(t::Term, p::PolynomialSparse128) = p + t

"""
Add two polynomials.
"""
function +(p1::PolynomialSparse128, p2::PolynomialSparse128)::PolynomialSparse128
    p = deepcopy(p1)
    for t in p2
        p += t
    end
    return p
end

"""
Add a polynomial and an integer.
"""
+(p::PolynomialSparse128, n::Int128) = p + Term(n,0)
+(n::Int128, p::PolynomialSparse128) = p + Term(n,0)