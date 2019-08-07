type 
    AnObject[T] = object
        val : T

proc varArgsTest(args : tuple) : void =
    for arg in args.fields:
        #Compile time checks to dispatch the behaviour according to types
        when arg is SomeInteger:
            echo "Some integer: " & $arg
        elif arg is string:
            echo "A string: " & $arg
        elif arg is ptr AnObject:  #check against ptr, addr of object is passed in
            echo "A pointer to AnObject: " & $arg[]
            arg.val = 123.342
            echo "A pointer to AnObject modified to: " & $arg[]

var 
    an_object = AnObject[float](val : 0.0)
    args = (10, "hello", addr an_object)   #Values that need modifications inside function must be passed in by ptr

echo "Variables before"
echo args[0]
echo args[1]
echo an_object
echo " "

#varArgsTest(args)

echo " "
echo "Variables after"
echo args[0]
echo args[1]
echo an_object   #It's been modified!