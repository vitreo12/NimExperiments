#tcc install:
#git clone git://repo.or.cz/tinycc.git
#cd tinycc/
#git checkout tags/release_0_9_27 (or another release)
#./configure (This is not needed.. it finds installations path, but I need them to be custom and embedded)
#make

#Different compiler with path... -d:danger also disables runtime checks, -d:release would keep them
#nim c --cc:tcc --tcc.exe=/home/francesco/Sources/tinycc/tcc --cincludes=/home/francesco/Sources/tinycc/include -d:danger -r "/home/francesco/Sources/nim/hello_world.nim"

#Also add linker: (probably not needed anyway...)
#nim c --cc:tcc --tcc.exe=/home/francesco/Sources/tinycc/tcc --tcc.linkerexe=/home/francesco/Sources/tinycc/tcc --cincludes=/home/francesco/Sources/tinycc/include -d:danger -r "/home/francesco/Sources/nim/hello_world.nim"


#GENERAL SOLUTION:
#[ type 
    TestType*[T, Y] = object  #"object" = stack allocated at instantiation. If it was "ref object", it meant heap allocated. "ref" can also just be added at construction of single objects.
        a : T
        b : Y

#Abstract the constructor away, to not write TestType[int, int] / TestType[string, string] / TestType[int, string]... etc... constructors everytime.
proc newTestType[T, Y](a : T, b : Y) : TestType[T, Y] = 
    return TestType[T, Y](a : a, b : b) ]#

#UGLY SOLUTION:
#[ type 
    AbstractType  = int or string
    AbstractType2 = int or string

    #If it was [T : AbstractType, Y : AbstractType], Nim would have assumed that both T and Y will store the same type, but not two different ones..
    TestType*[T : AbstractType, Y : AbstractType2] = object
        a : T
        b : Y

proc newTestType[T : AbstractType, Y : AbstractType](a : T, b : Y) : TestType[T, Y] = 
    return TestType[T, Y](a : a, b : b) ]#

#MIXED SOLUTION
type 
    AbstractType  = int or string

    #Fully generic type, but constrained in the procs interface. If importing this module, a new TestType can only be constructed with the newTestType function, as its field members are not exported.
    TestType*[T, Y] = object  
        a : T
        b : Y

#When importing this module, the only way of creating a TestType object is by using newTestType.
proc newTestType*[T : AbstractType, Y : AbstractType](a : T, b : Y) : TestType[T, Y] = 
    return TestType[T, Y](a : a, b : b)

proc print_test_type*(t : TestType) =
    echo t.a
    echo t.b

let 
    t1 = newTestType(1, 2)               #TestType[int, int]
    t2 = newTestType("string", "here")   #TestType[string, string]
    t3 = newTestType(10, "mixed")        #TestType[int, string]

echo typedesc(t1)
print_test_type(t1)

echo typedesc(t2)
print_test_type(t2)

echo typedesc(t3)
print_test_type(t3)