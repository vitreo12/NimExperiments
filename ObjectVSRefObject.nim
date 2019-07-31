type 
    MyObject = object
        a : int

    MyOtherObject = ref object
        a : int

proc newMyObject(a : int) : MyObject = 
    result = MyObject(a : a)

#Creates an object on the stack, and returns the actual object
let a = newMyObject(1)

echo "a : ", type(a), " = ", a

#Creates a object on the heap, and returns its pointer
proc newRefMyObject(a : int) : ref MyObject = 
    result = new MyObject
    result.a = a

let b = newRefMyObject(2)

echo "b : ", type(b), " = ", b[]
echo "b[] : ", type(b[]) #It actually points to a MyObject

#Initialization of a ref object type
var c : MyOtherObject
c = MyOtherObject(a : 1)

#Here c is just a MyOtherObject, which itself is a ref object type.
echo "c : ", type(c), " = ", c[]

echo "c[] : ", type(c[])