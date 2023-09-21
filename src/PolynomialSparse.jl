#############################################################################
#############################################################################
#
# This file defines the polynomial type with several operations 
#                                                                               
#############################################################################
#############################################################################

####################################
# Polynomial type and construction #
####################################
using DataStructures, Random

include("term.jl")

##################################################
# Enforcing sorting and connecting to dictionary #
##################################################

"""
Assumes that the element `V` has an order (i.e. you can use <).

Assumes that the linked list `lst` is already sorted.

Assumes the dictionary `dict` does not have the key `key`.

Inserts the new element `value` to the list in its sorted position and updates the dictionary with `key` to point at the node of the linked list.
"""
function insert_sorted!(    lst::MutableLinkedList{V}, 
                            dict::Dict{K, DataStructures.ListNode{V}},
                            key::K,
                            value::V)::Nothing where {K,V}

    #Note that MutableLinkedList is implemented as a doubly pointed linked list 
    #The element lst.node is a root which points at the head and the tail.
    # lst.node.prev is the last element of the list
    # lst.node.next is the first element of the list

    haskey(dict, key) && error("Key is already in dict")
    
    #If list is empty or the value is greater than end of list, push at end
    if isempty(lst) || last(lst) <= value
        push!(lst, value)
        dict[key] = lst.node.prev #point to last since value just added to last
        return nothing
    end
    
    #if here then lst is not empty
    current_node = lst.node.next #point at first node
    i = 1
    #iterate to find 
    while current_node.data <= value
        # if current_node == lst.node.prev #if got to last node
        #     push!(lst, value) #just push at end
        #     dict[key] = lst.node.prev #point to last
        #     return nothing
        # end
        current_node = current_node.next #move to next node
    end

    #if here then current_node points at right place
    new_node = DataStructures.ListNode{V}(value) #create a new node

    #tie new_node between current_node.prev and current_node
    new_node.prev = current_node.prev 
    new_node.next = current_node

    #tie prev to new_node
    new_node.prev.next = new_node

    #tie next to new_node
    new_node.next.prev = new_node

    lst.len += 1
    dict[key] = new_node
    return nothing
 end

"""
Assumes the dictionary `dict` has the key `key`. and it is pointing at the linked list.
"""
function delete_element!(   lst::MutableLinkedList{V}, 
                            dict::Dict{K, DataStructures.ListNode{V}},
                            key::K)::Nothing where {K,V}

    haskey(dict, key) || error("Key is not in dict")

    node = dict[key]
    delete!(dict, key)

    node.prev.next = node.next
    node.next.prev = node.prev
    lst.len -= 1

    return nothing
end

"""
Returns the value associated with the key `key` or `nothing` if not in list.
"""
get_element(    lst::MutableLinkedList{V}, 
                dict::Dict{K, DataStructures.ListNode{V}},
                key::K) where {K,V} = haskey(dict, key) ? dict[key].data : nothing

"""
Returns the element following the element associated with the key `key` or `nothing` if there is no next element.
Throws an error if `key` is not available.
"""
function get_next_element(  lst::MutableLinkedList{V}, 
                            dict::Dict{K, DataStructures.ListNode{V}},
                            key::K) where {K,V}
    
    haskey(dict, key) || error("Key is not in dict")
    node = dict[key]
    node.next == lst.node && return nothing
    return node.next.data
end

####################################################################

#####################################
# Polynomial Definition and Methods #
#####################################

"""
A Polynomial type - designed to be for polynomials with integer coefficients.
"""
struct Polynomial

    #A linked-list that represents a series of terms
    #Terms are assumed to be in order with first term having degree 0, second degree 1, and so fourth
    #until the degree of the polynomial. The leading term (i.e. last) is assumed to be non-zero except 
    #for the zero polynomial where the linked-list is of length 1.
    #Note: at positions where the coefficient is 0, the power of the term is also 0 (this is how the Term type is designed)
    terms::MutableLinkedList{Term}

    #A Dictionary that maps the degree of a term to the corresponding node(represents a term) 
    # in the linked-list
    degreeDict::Dict{Int, DataStructures.ListNode{Term}}
    
    #Inner constructor of 0 polynomial(`terms` is an empty linked-list in this case)
    #call overloaded constructor
    Polynomial() = Polynomial([zero(Term)])

    #Inner constructor of polynomial based on arbitrary list of terms
    function Polynomial(vt::Vector{Term})
        #Filter the vector so that there is not more than a single zero term
        vt = filter((t)->!iszero(t), vt)
        if isempty(vt)
            vt = [zero(Term)]
        end

        l = MutableLinkedList{Term}()
        d = Dict{Int, DataStructures.ListNode{Term}}()

        #update `terms` and `degreeDict` based on the terms in `vt`
        for t in vt
            # TODO Why t.degree typed Int64? however it is defined as Int in `Term`
            # @show (typeof(l), typeof(d), typeof(t.degree), typeof(t))

            #call helper function
            insert_sorted!(l, d, t.degree, t)
        end
        return new(l, d)
    end

    #Inner constructor of polynomial based on arbitrary list of terms
    function Polynomial(lst::MutableLinkedList{Term})
        #populate degreeDict
        l = MutableLinkedList{Term}()
        d = Dict{Int, DataStructures.ListNode{Term}}()
        for node in lst
            # TODO how to convert `Term` into `ListNode{Term}`
            # `l` and `lst` ocuppied double memory
            insert_sorted!(l, d, node.degree, node)
        end
        return new(l, d)
    end
end

"""
This function maintains the invariant of the Polynomial type so that there are no zero terms beyond the highest
non-zero term.
"""
function trim!(p::Polynomial)::Polynomial
    #how many terms
    n = length(p.terms)
    if n <= 1
        return p
    end

    #iterate the `degreeDict` and delete any zero terms
    for (degree, term) in p.degreeDict
        if iszero(term)
            delete_element!(p.terms, p.degreeDict, degree)
        end
    end
end

"""
Construct a polynomial with a single term.
"""
Polynomial(t::Term) = Polynomial([t])

"""
Construct a polynomial of the form x^p-x.
"""
cyclotonic_polynomial(p::Int) = Polynomial([Term(1,p), Term(-1,0)])


"""
Construct a polynomial of the form x-n.
"""
linear_monic_polynomial(n::Int) = Polynomial([Term(1,1), Term(-n,0)])

"""
Construct a polynomial of the form x.
"""
x_poly() = Polynomial(Term(1,1))

"""
Creates the zero polynomial.
"""
zero(::Type{Polynomial})::Polynomial = Polynomial()

"""
Creates the unit polynomial.
"""
one(::Type{Polynomial})::Polynomial = Polynomial(one(Term))
one(p::Polynomial) = one(typeof(p))

"""
Generates a random polynomial.
"""
function rand(::Type{Polynomial} ; 
                degree::Int = -1, 
                terms::Int = -1, 
                max_coeff::Int = 100, 
                mean_degree::Float64 = 5.0,
                prob_term::Float64  = 0.7,
                monic = false,
                condition = (p)->true)
        
    while true 
        _degree = degree == -1 ? rand(Poisson(mean_degree)) : degree
        _terms = terms == -1 ? rand(Binomial(_degree,prob_term)) : terms
        degrees = vcat(sort(sample(0:_degree-1,_terms,replace = false)),_degree)
        coeffs = rand(1:max_coeff,_terms+1)
        monic && (coeffs[end] = 1)
        p = Polynomial( [Term(coeffs[i],degrees[i]) for i in 1:length(degrees)] )
        condition(p) && return p
    end
end

###########
# Display #
###########

"""
Show a polynomial.
"""
const lowest_to_highest_default = false  #if lowest_to_highest is not set then it is false.
global lowest_to_highest            #set a global variable for lowest_to_highest.

function show(io::IO, p::Polynomial) 
    if iszero(p)
        print(io,"0")
        return
    end
    first_term = true
    #Check if `lowest_to_highest` is defined. 
    #Since this is an `order_to_use` is a boolean value, 
    #if `lowest_to_highest` is entered with a value other than `true` or `false`, then the code will report an error
    order_to_use = isdefined(Main, :lowest_to_highest) ? lowest_to_highest : lowest_to_highest_default

    if order_to_use
        term_range = 1:length(p.terms)
    else
        term_range = length(p.terms):-1:1
    end
    
    
    for i in term_range
        t = p.terms[i]
        if !iszero(t)
            # If it's not the first term and the coefficient is positive, add a "+"
            if !first_term && t.coeff > 0
                print(io, " + ")
            end
            # If it's not the first term and the coefficient is negative, add a "-"
            if !first_term && t.coeff < 0
                print(io, " - ")
            end
            if t.coeff < 0
                show(io, Term(-t.coeff, t.degree))  # Display the absolute value
            else
                show(io, t)
            end
            first_term = false
        end
    end
end




##############################################
# Iteration over the terms of the polynomial #
##############################################

"""
Makes the linked list iterable. 
Allows to do iteration over the non-zero terms of the polynomial. This implements the iteration interface.
@see ../sorted_linked_list.jl
"""

"""
Makes the linked list iterable. 
"""
function iterateLinkedList(lst::MutableLinkedList{T}, state=lst.node.next) where T 
    state == lst.node.prev ? nothing : (lst.node.data, lst.node.next)
end

iterate(p::Polynomial, state=1) = iterateLinkedList(p.terms, p.terms.node.next)


##############################
# Queries about a polynomial #
##############################

"""
The number of terms of the polynomial.
"""
length(p::Polynomial) = length(p.terms) 

"""
The leading term of the polynomial.
"""
leading(p::Polynomial)::Term = isempty(p.terms) ? zero(Term) : last(p.terms) 

"""
Returns the coefficients of the polynomial.
"""
coeffs(p::Polynomial)::Vector{Int} = [t.coeff for t in p]

"""
The degree of the polynomial.
"""
degree(p::Polynomial)::Int = leading(p).degree 

"""
The content of the polynomial is the GCD of its coefficients.
"""
content(p::Polynomial)::Int = euclid_alg(coeffs(p))

"""
Evaluate the polynomial at a point `x`.
"""
evaluate(f::Polynomial, x::T) where T <: Number = sum(evaluate(t,x) for t in f)

################################
# Pushing and popping of terms #
################################

"""
Push a new term into the polynomial.
"""
#Note that ideally this would throw and 
# TODO handle if pushing another term of degree that is already in the polynomial
function push!(p::Polynomial, t::Term) 
    # if t.degree <= degree(p)
    #     p.terms[t.degree + 1] = t
    # else
    #     append!(p.terms, zeros(Term, t.degree - degree(p)-1))
    #     push!(p.terms, t)
    # end
    sorted_insert!(p.terms, p.degreeDict, t.degree, t)
    return p        
end

"""
Pop the leading term out of the polynomial. When polynomial is 0, keep popping out 0.
"""
function pop!(p::Polynomial)::Term 
    popped_term = pop!(p.terms) #last element popped is leading coefficient

    while !isempty(p.terms) && iszero(last(p.terms))
        pop!(p.terms)
    end

    if isempty(p.terms)
        push!(p.terms, zero(Term))
    end

    return popped_term
end

"""
Check if the polynomial is zero.
"""
iszero(p::Polynomial)::Bool = p.terms == [Term(0,0)]

#################################################################
# Transformation of the polynomial to create another polynomial #
#################################################################

"""
The negative of a polynomial.
"""
-(p::Polynomial) = Polynomial(map((pt)->-pt, p.terms))

"""
Create a new polynomial which is the derivative of the polynomial.
"""
function derivative(p::Polynomial)::Polynomial 
    der_p = Polynomial()
    for term in p
        der_term = derivative(term)
        !iszero(der_term) && push!(der_p,der_term)
    end
    return trim!(der_p)
end

"""
The prim part (multiply a polynomial by the inverse of its content).
"""
prim_part(p::Polynomial) = p ÷ content(p)


"""
A square free polynomial.
"""
square_free(p::Polynomial, prime::Int)::Polynomial = (p ÷ gcd(p,derivative(p),prime))(prime)

#################################
# Queries about two polynomials #
#################################

"""
Check if two polynomials are the same
"""
==(p1::Polynomial, p2::Polynomial)::Bool = p1.terms == p2.terms


"""
Check if a polynomial is equal to 0.
"""
#Note that in principle there is a problem here. E.g The polynomial 3 will return true to equalling the integer 2.
==(p::Polynomial, n::T) where T <: Real = iszero(p) == iszero(n)

##################################################################
# Operations with two objects where at least one is a polynomial #
##################################################################

"""
Subtraction of two polynomials.
"""
-(p1::Polynomial, p2::Polynomial)::Polynomial = p1 + (-p2)


"""
Multiplication of polynomial and term.
"""
*(t::Term, p1::Polynomial)::Polynomial = iszero(t) ? Polynomial() : Polynomial(map((pt)->t*pt, p1.terms))
*(p1::Polynomial, t::Term)::Polynomial = t*p1

"""
Multiplication of polynomial and an integer.
"""
*(n::Int, p::Polynomial)::Polynomial = p*Term(n,0)
*(p::Polynomial, n::Int)::Polynomial = n*p

"""
Integer division of a polynomial by an integer.

Warning this may not make sense if n does not divide all the coefficients of p.
"""
÷(p::Polynomial, n::Int) = (prime)->Polynomial(map((pt)->((pt ÷ n)(prime)), p.terms))

"""
Take the mod of a polynomial with an integer.
"""
function mod(f::Polynomial, p::Int)::Polynomial
    f_out = deepcopy(f)
    for i in 1:length(f_out.terms)
        f_out.terms[i] = mod(f_out.terms[i], p)
    end
    return trim!(f_out)
        
    # p_out = Polynomial()
    # for t in f
    #     new_term = mod(t, p)
    #     @show new_term
    #     push!(p_out, new_term)
    # end
    # return p_out
end

"""
Power of a polynomial mod prime.
"""
function pow_mod(p::Polynomial, n::Int, prime::Int)
    n < 0 && error("No negative power")
    out = one(p)
    for _ in 1:n
        out *= p
        out = mod(out, prime)
    end
    return out
end