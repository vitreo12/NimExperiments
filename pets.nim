{.experimental: "codeReordering".}

type
    Pet {.inheritable.} = object
        name : string

    Dog = object of Pet
    Cat = object of Pet

#correctly compiles, as a : P1  and b : P2 are concrete subtypes (Dog and Cat) of the Pet object
proc encounter[P1 : Pet, P2 : Pet](a : P1, b : P2) =
    let verb = meets(a, b)
    echo $a.name & " " & verb & " " & $b.name

#using this other form would give error: no "meets" proc defined for (Pet, Pet)
#[
proc encounter2(a : Pet, b : Pet) =
    let verb = meets(a, b)
    echo $a.name & " " & verb & " " & $b.name
]#

proc meets(a : Dog, b : Cat) : string =
    return "chases"

let
    a = Dog(name : "Fido")
    b = Cat(name : "Kitty")

encounter(a, b)