#Refer to: https://forum.nim-lang.org/t/5010
#and https://github.com/nim-lang/Nim/issues/11747

type
    MyType = object
        a : int64
        b : float64

#Allocate memory
let my_type_raw_ptr = alloc(sizeof(MyType))

#This will copy the memory layout over to the stack, and create a new object out of it?
var my_type_var : MyType = cast[MyType](my_type_raw_ptr)

my_type_var.a = 1
my_type_var.b = 2.3

echo my_type_var

#This will literaly just cast the pointer to be a pointer to a correct MyType type. No need for "ref" instead of "ptr", as underlying memory is not tracked by the GC.
let my_type_ptr : ptr MyType = cast[ptr MyType](my_type_raw_ptr)

#Even if immutable, its values can be changed (but the pointer that my_type_ptr points to cannot)
my_type_ptr.a = 10
my_type_ptr.b = 23.0

#Unload the ptr... returns a MyType
echo my_type_ptr[]

#Both the original pointer and the ref pointer are pointing to the same location in memory.
if cast[uint](my_type_raw_ptr) == cast[uint](my_type_ptr):    
    echo "SAME POINTER" 

#deallocate memory
dealloc(my_type_raw_ptr)

#Do the same thing for a ref object:
type 
    MyTypeRef = ref object
        a : int64
        b : float64

    #Retrieve the underlying struct and extract its type, which is an "object", not "ref object"... Does MyTypeRef() actually allocate a MyTypeRef object??
    MyTypeRefUnderlyingObject = type(MyTypeRef()[])

let my_type_ref_raw_ptr = alloc(sizeof(MyTypeRefUnderlyingObject))

#Correct size: 
echo sizeof(MyTypeRefUnderlyingObject)

#This will copy the memory layout over to the stack, and create a new object out of it?
var my_type_ref_var : MyTypeRefUnderlyingObject = cast[MyTypeRefUnderlyingObject](my_type_raw_ptr)

my_type_ref_var.a = 2
my_type_ref_var.b = 4.35

echo my_type_ref_var 

#I can use the ref object type directly, as it's just a ref counted pointer. Otherwise, I could have used "ptr MyTypeRefUnderlyingObject"
let my_type_ref_ptr : MyTypeRef = cast[MyTypeRef](my_type_ref_raw_ptr)

my_type_ref_ptr.a = 3
my_type_ref_ptr.b = 5.654

echo my_type_ref_ptr[]

#Both the original pointer and the ref pointer are pointing to the same location in memory.
if cast[uint](my_type_ref_raw_ptr) == cast[uint](my_type_ref_ptr):    
    echo "SAME POINTER" 

dealloc(my_type_ref_raw_ptr)