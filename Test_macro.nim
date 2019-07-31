import macros

macro test(num_of_inputs : untyped, code_block : untyped) : untyped =
    #Loop over all statements
    for statement in code_block.children():
        var a = astGenRepr(statement)
        echo a

test 2:
    "[1, 2, 3]"
    "1"