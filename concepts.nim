{.experimental: "codeReordering".}

type
  CanDance = concept x
    dance(x) # `x` is anything that has a `dance` procedure

#needs the codeReordering experimental flag to work
proc doBallet(dancer : CanDance) =
    dancer.dance
    
# ---

type
  Person = object
  Robot = object

proc dance(p: Person) =
  echo "People can dance, but not Robots!"
    
# ---

let p = Person()
let r = Robot()

doBallet(p) # works. prints: "People can dance, but not Robots!"
#doBallet(r) # ERROR: (expected a type which CanDance)