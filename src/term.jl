#############################################################################
#############################################################################
#
# This file defines the Term type with several operations 
#                                                                               
#############################################################################
#############################################################################

##############################
# Term type and construction #
##############################

struct i128 end
(*)(n, ::Type{i128}) = Int128(n)

"""
A term.
"""
struct Term  #structs are immutable by default
    coeff::Int128
    degree::Int128
    function Term(coeff::Int128, degree::Int128)
        degree < 0 && error("Degree must be non-negative")
        coeff != 0 ? new(coeff, degree) : new(coeff, 0)
    end
end

"""
Creates the zero term.
> Nekomiya: why takes 1 argument? no need for arguments to create a default instance.
"""
zero::Term = Term(0i128, 0i128)

"""
Creates the unit term.
"""
one::Term = Term(1i128, 1i128)

###########
# Display #
###########

"""
Show a term.
"""
function show(io::IO, t::Term)
    # Skip terms with zero coefficients
    if t.coeff == 0
        return
    end
    # Handle the constant term (degree 0)
    if t.degree == 0
        print(io, "$(t.coeff)")
        # Handle terms where the coefficient is 1 and degree is greater than 1
    elseif t.coeff == 1 && t.degree > 1
        print(io, "x$(int_to_unicode(t.degree))")
        # Handle terms where the coefficient is 1 and degree is 1
    elseif t.coeff == 1 && t.degree == 1
        print(io, "x")
        # Handle terms where the coefficient is -1 and degree is 1
    elseif t.coeff == -1 && t.degree == 1
        print(io, "-x")
        # Handle all other cases
    else
        # If degree is 1, don't show the power
        # Otherwise, display both coefficient and power
        print(io, t.degree == 1 ? "$(t.coeff)⋅x" : "$(t.coeff)⋅x$(int_to_unicode(t.degree))")
    end
end

########################
# Queries about a term #
########################

"""
Check if a term is 0.
"""
iszero(t::Term)::Bool = iszero(t.coeff)

"""
Compare two terms.
"""
isless(t1::Term, t2::Term)::Bool = t1.degree == t2.degree ? (t1.coeff < t2.coeff) : (t1.degree < t2.degree)

"""
Evaluate a term at a point x.
"""
evaluate(t::Term, x::T) where {T<:Number} = t.coeff * x^t.degree

##########################
# Operations with a term #
##########################

"""
Add two terms of the same degree.
"""
function +(t1::Term, t2::Term)::Term
    @assert t1.degree == t2.degree
    Term(t1.coeff + t2.coeff, t1.degree)
end

"""
Negate a term.
"""
-(t::Term,) = Term(-t.coeff, t.degree)

"""
Subtract two terms with the same degree.
"""
-(t1::Term, t2::Term)::Term = t1 + (-t2)

"""
Multiply two terms.
"""
*(t1::Term, t2::Term)::Term = Term(t1.coeff * t2.coeff, t1.degree + t2.degree)

"""
Compute the symmetric mod of a term with an integer.
"""
mod(t::Term, p::Int) = Term(mod(t.coeff, p), t.degree)
mod(t::Term, p::Int) = Term(mod(t.coeff, p), t.degree)

"""
Compute the derivative of a term.
"""
derivative(t::Term) = Term(t.coeff * t.degree, max(t.degree - 1, 0))

"""
Divide two terms. Returns a function of an integer.
"""
function ÷(t1::Term, t2::Term) #\div + [TAB]
    @assert t1.degree ≥ t2.degree
    f(p::Int)::Term = Term(mod((t1.coeff * int_inverse_mod(t2.coeff, p)), p), t1.degree - t2.degree)
end

"""
Integer divide a term by an integer.
"""
÷(t::Term, n::Int) = t ÷ Term(n, 0)
