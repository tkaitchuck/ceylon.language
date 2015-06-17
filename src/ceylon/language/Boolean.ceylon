"A type capable of representing the values [[true]] and 
 [[false]] of Boolean logic."
see (`function parseBoolean`) 
by ("Gavin")
shared abstract class Boolean()
        of true | false satisfies Immutable {}

"A value representing truth in Boolean logic."
shared native object true 
        extends Boolean() {
    string => "true";
}

"A value representing falsity in Boolean logic."
shared native object false 
        extends Boolean() {
    string => "false";
}
