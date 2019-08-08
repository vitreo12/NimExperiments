type
    MyVector[T] = object
        data : seq[T]

#See https://github.com/nim-lang/RFCs/issues/85 for a discussion about typedesc vs generics
proc newMyVector(size : Natural = 0, T : typedesc = typedesc[float]) : MyVector[T] =
    result = MyVector[T](data : newSeq[T](size))

proc `[]`*[I : Ordinal; T](a : MyVector[T], i : I) : T {.noSideEffect.} =
    return a.data[i]

proc `[]=`*[I : Ordinal; T, S](a : var MyVector[T], i : I, x : S) : void =
    a.data[i] = x

proc len[T](a : MyVector[T]) : int {.noSideEffect.} =
    return a.data.len
    
proc `*`[T](a : MyVector[T], b : T) : MyVector[T] =
    result = newMyVector(a.len, T)
    for i in 0..a.len-1:
        result[i] = a[i] * b

#See https://github.com/nim-lang/RFCs/issues/85 for a discussion about typedesc vs generics
#The "T : type = type float" syntax is the same as "T : typedesc = typedesc[float]"
proc ones(size : Natural = 0, T : type = type float) : MyVector[T] =
    result = newMyVector(size, T)
    for i in 0..size-1:
        result[i] = T(1)

#Defaults to float
var a = ones(10)

let b = a * 0.5

echo a.data
echo b.data