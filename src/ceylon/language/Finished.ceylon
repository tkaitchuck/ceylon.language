"The type of the value that indicates that an [[Iterator]] 
 is exhausted and has no more values to return."
see (`interface Iterator`)
shared abstract class Finished() of finished satisfies Immutable {}

"A value that indicates that an [[Iterator]] is exhausted 
 and has no more values to return."
see (`interface Iterator`)
shared object finished extends Finished() {
    string => "finished";
}

