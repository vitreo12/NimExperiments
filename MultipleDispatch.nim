{.experimental: "codeReordering".}

#########
# TYPES #
#########

#general function, fallback
proc f[T, Y](a : T, b : Y) =
    echo "fallback: " & $(typeof(a)) & ", " & $(typeof(b))

#specialized functions only work with concrete syntax, without T
proc f(a, b : SomeInteger) =
    echo "integers: " & $(typeof(a))

proc f(a, b : SomeFloat) =
    echo "floats: " & $(typeof(a))

proc f(a : SomeInteger, b : SomeFloat) =
    echo "integer and float: " & $(typeof(a)) & ", " & $(typeof(b))

proc f(a : SomeFloat, b : SomeInteger) =
    echo "float and integer: " & $(typeof(a)) & ", " & $(typeof(b))
        
f(1, 2)

f(1.4, 0.4)

f(2, 0.4)

f(0.9, 2)

f(1, "hello")


###########
# OBJECTS #
###########

#dispatch with abstract objects
type
    AbstractType[T] = object of RootObj
        val : T

    ConcreteType1[T] = object of AbstractType[T]
    ConcreteType2[T] = object of AbstractType[T]

#function on concrete instantiation of AbstractType
proc funcOnAbstractTypes[T : auto, AT1 : AbstractType[T], AT2 : AbstractType[T]](a : AT1, b : AT2) =
    funcOnConcreteTypes(a, b)

proc funcOnConcreteTypes[T](a : ConcreteType1[T], b : ConcreteType2[T]) =
    echo "Concrete types 1 and 2: " & $(typeof(a)) & ", " & $(typeof(b))

proc funcOnConcreteTypes[T](a : ConcreteType2[T], b : ConcreteType1[T]) =
    echo "Concrete types 2 and 1: " & $(typeof(a)) & ", " & $(typeof(b))
let 
    a = ConcreteType1[float](val : 0.5)
    b = ConcreteType2[float](val : 2.4)

funcOnAbstractTypes(a, b)
funcOnAbstractTypes(b, a)