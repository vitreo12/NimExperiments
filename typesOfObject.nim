import macros

proc recursiveTypesOfObject(t : NimNode, typeToFind : string = " ") : void {.compileTime.} =
    
    var z: seq[array[2, string]] = @[]

    let typDef = getImpl(t)

    #builtins return nnkNilLit
    if typDef.kind != nnkNilLit:

        let actual_type = typDef[2].kind

        var recList : NimNode

        #object
        if actual_type == nnkObjectTy: 
        
            #inheritance
            if typDef[2][1].kind == nnkOfInherit:
                let parent = typDef[2][1][0]
                echo $t & "'s parent: " & $parent.strVal
                #recursively run the same function on the parent
                recursiveTypesOfObject(parent)
                
            recList = typDef[2][2]

        #some kind of ref object
        elif actual_type == nnkRefTy:
            let errorString = "Cannot inspect " & $t & ": it is a ref object. Only normal objects are supported"
            error(errorString)

            #[
            let objTyp = typDef[2][0]

            #pure defined ref object
            if objTyp.kind == nnkObjectTy:
                recList = objTyp[2]

            #RefObj = ref Obj
            else:
                let objTypTypDef = getImpl(objTyp)
                recList = objTypTypDef[2][2]
            ]#

        #retrieve fields and append them to seq
        for identDefs in recList:
            #recursively run the function on the field types
            recursiveTypesOfObject(identDefs[1])
            z.add [$identDefs[0], $identDefs[1]]

    echo $t & ": " & $z
    #echo " "

    #tree reprenstation
    #echo treeRepr(typDef)

    #AST representation
    #echo astGenRepr(typDef)

    #echo " "
    
#does not work with ref object types
macro getTypesOfObject(t: typed) =
    recursiveTypesOfObject(t)

type
    MyObj {.inheritable.} = object 
        a : int
        b : float

    MyInheritedObj = object of MyObj

    MyRefObj = ref MyObj

    AnotherRefObj = ref object of RootObj
        c : float
        d : string

    InheritedRefObj = ref object of AnotherRefObj

    MyOtherObj = object
        obj : MyObj

    MyOtherOtherObj = object
        otherObj : MyOtherObj


getTypesOfObject(float)
getTypesOfObject(MyObj)
getTypesOfObject(MyInheritedObj)

#[
getTypesOfObject(MyRefObj)
getTypesOfObject(AnotherRefObj)
getTypesOfObject(InheritedRefObj)
#getTypesOfObject(MyOtherObj)
#getTypesOfObject(MyOtherOtherObj)
]#