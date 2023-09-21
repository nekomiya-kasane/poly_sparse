#############################################################################
#############################################################################
#
# This file implements polynomial multiplication 
#                                                                               
#############################################################################
#############################################################################

"""
Multiply two polynomials.
"""
function *(p1::Polynomial, p2::Polynomial)::Polynomial
    p_out = Polynomial()
    for t1 in p1.terms
        for t2 in p2.terms
            new_summand = t1 * t2
            p_out = p_out + new_summand
        end
    end

    # for t in p1
    #     new_summand = (t * p2)  # if Polynomial were iterable!
    #     p_out = p_out + new_summand
    #     end
    return p_out
end

"""
Power of a polynomial.
"""
function ^(p::Polynomial, n::Int)
    n < 0 && error("No negative power")
    out = one(p)

    for _ in 1:n
        @show typeof(out), typeof(p)
        out *= p
    end
    return out
end

