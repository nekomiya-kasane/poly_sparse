#############################################################################
#############################################################################
#
# This file contains units tests for polynomial factorization
#                                                                               
#############################################################################
#############################################################################

"""
Test factorization of polynomials.
"""
function factor_test_poly(;N::Int128 = 10, seed::Int128 = 0, primes::Vector{Int128} = [5,17,19])
    Random.seed!(seed)
    for prime in primes
        print("\ndoing prime = $prime \t")
        for _ in 1:N
            print(".")
            p = rand(Polynomial)
            factorization = factor(p, prime)
            pr = mod(expand_factorization(factorization),prime)
            @assert mod(p-pr,prime) == 0 
        end
    end

    println("\nfactor_test_poly - PASSED")
end

