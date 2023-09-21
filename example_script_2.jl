using Pkg
Pkg.activate(".")

include("poly_factorization_project.jl")

x = x_poly()
# @show x, 2x
@show 2x + x

@show cyclotonic_polynomial(3)
@show linear_monic_polynomial(42)

println("===== Basic Polynomial Operations =====")
# p1 = 2x^3 + 4x^2 - 3x
# p1 = 2x^3
# @show x^2 + x
# println("p1: ", p1)

# p2 = 2x^4 - 4x^2 - 3x + 3
# println("p2: ", p2)

# # Display multiplication
# mult_res = p1 * p2
# println("p1 * p2: ", mult_res)

# # Display addition
# add_res = p1 + p2
# println("p1 + p2: ", add_res)

# # Display subtraction
# sub_res = p1 - p2
# println("p1 - p2: ", sub_res)

# println("\n===== Derivative Operations =====")
# # Show derivative of a polynomial
# deriv_res = derivative(p1)
# println("Derivative of p1: ", deriv_res)

# deriv_mult_res = derivative(p1*p2)
# println("Derivative of p1*p2: ", deriv_mult_res)


# println("\n===== Take the mod of a polynomial with an integer =====")
# prime = 23
# p3 = mod(4x^4 + 3x^3 + 7x^2 + x + 5, prime)
# p4 = mod(x^3 + 6x^2 + 8x + 12, prime)
# println("p3 (mod $prime): ", p3)
# println("p4 (mod $prime): ", p4)

# # Display multiplication in mod prime
# mult_mod_res = mod(p3*p4, prime)
# println("p3 * p4 (mod $prime): ", mult_mod_res)

# # Factorization of polynomial in mod prime
# println("\nFactorizing p3 (mod $prime):")
# factorization_p3 = factor(p3, prime)
# println("Factorization of p3: ", factorization_p3)

# # Reconstructing polynomial from its factorization
# reconstructed_p3 = mod(expand_factorization(factorization_p3), prime)
# println("Reconstructed p3: ", reconstructed_p3)


# println("\n===== Extended Euclidean Algorithm =====")
# ext_euclid_result = extended_euclid_alg(p1*p2, p2, prime)
# println("Using extended_euclid_alg for p1*p2 and p2 (mod $prime): ", ext_euclid_result)

