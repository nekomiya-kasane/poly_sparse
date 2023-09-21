#############################################################################
#############################################################################
#
# This file defines some functions to solve some problems.
#                                                                               
#############################################################################
#############################################################################


   
"""
This functions use for ennahnce pretty printing with Unicode  
"""
function int_to_unicode(n::Int)::String
    # Dictionary mapping integers to their superscript representations
    unicodeSusperscript = Dict(
        0 => '⁰',
        1 => '¹',
        2 => '²',
        3 => '³',
        4 => '⁴',
        5 => '⁵',
        6 => '⁶',
        7 => '⁷',
        8 => '⁸',
        9 => '⁹'
    )
    
    str = string(n)
    return join([unicodeSusperscript[parse(Int, char)] for char in str])
end
