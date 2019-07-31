#Compare with WrapCArray.nim.c ... It's the safest way.

var a_ptr  = alloc0(sizeof(ptr cfloat) * 2)     #float**

var a_ptr1 = alloc0(sizeof(cfloat) * 10)        #float*
var a_ptr2 = alloc0(sizeof(cfloat) * 10)        #float*

type
    CFloatPtr    = ptr UncheckedArray[cfloat]
    CFloatPtrPtr = ptr UncheckedArray[CFloatPtr]

var
    a  = cast[CFloatPtrPtr](a_ptr)              #float**
    a1 = cast[CFloatPtr](a_ptr1)                #float*
    a2 = cast[CFloatPtr](a_ptr2)                #float*

#Assign the single float* to the float** array
a[0] = a1
a[1] = a2

#Modify values of the array
a[0][0] = 1.0
a[1][8] = 2.0

#Check if values were actually modified
echo a1[0]
echo a2[8]

#Free memory
dealloc(a_ptr)
dealloc(a_ptr1)
dealloc(a_ptr2)