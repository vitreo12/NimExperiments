type
    MyVector[T] = object
        data : seq[T]

proc newMyVector[T](size : Natural = 0) : MyVector[T] =
    result = MyVector[T](data : newSeq[T](size))
    
proc `*`[T](a : MyVector[T], b : T) : MyVector[T] =
    result = newMyVector[T](a.data.len)
    for i in 0..a.data.len-1:
        result.data[i] = a.data[i] * b

proc ones(size : Natural = 0, T : type = type float) : MyVector[T] =
    result = newMyVector[T](size)
    for i in 0..size-1:
        result.data[i] = T(1)
        
var a = ones(100)

let b = a * 0.5

echo a.data
echo b.data

echo default(float)