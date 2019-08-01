{.experimental: "codeReordering".}

type
    AbstractType[T]  = object of RootObj
        value : T

    ConcreteType1[T] = object of AbstractType[T]
    ConcreteType2[T] = object of AbstractType[T]

#Constructors without init val specification
proc newConcreteType1[T](inValue : T) : ConcreteType1[T] =
    return ConcreteType1[T](value : inValue)

proc newConcreteType2[T](inValue : T) : ConcreteType2[T] =
    return ConcreteType2[T](value : inValue)

#correctly compiles, as "a : AT1" and "b : AT2" are concrete subtypes (ConcreteType1 and ConcreteType2) of the AbstractType object
#"T : auto" and "Y : auto" are required to generalize the generic type of "AbstractType[T"]" and "AbstractType[Y]". It works just like Julia's Any. Nim's "any" won't work.
proc encounter [T : auto, Y : auto, AT1 : AbstractType[T], AT2 : AbstractType[Y]] (a : AT1, b : AT2) =
    let interaction = interact(a, b)
    echo $a.value & " " & interaction & " " & $b.value

#Dispatch on concrete types
proc interact[T, Y](a : ConcreteType1[T], b : ConcreteType1[Y]) : string =
    return "**** C1 - C1 ****"

proc interact[T, Y](a : ConcreteType1[T], b : ConcreteType2[Y]) : string =
    return "**** C1 - C2 ****"

proc interact[T, Y](a : ConcreteType2[T], b : ConcreteType1[Y]) : string =
    return "**** C2 - C1 ****"

proc interact[T, Y](a : ConcreteType2[T], b : ConcreteType2[Y]) : string =
    return "**** C2 - C2 ****"

#Define variables
let
    a = newConcreteType1("ConcreteType1 string")  #ConcreteType1[string]
    b = newConcreteType2("ConcreteType2 string")  #ConcreteType2[string]
    c = newConcreteType1(1500)                    #ConcreteType1[int]
    d = newConcreteType2(2000)                    #ConcreteType2[int]

#Run the encounters
encounter(a, b)
encounter(c, d)
encounter(a, c)
encounter(b, d)