"The result of a comparison between two [[Comparable]] 
 objects: [[larger]], [[smaller]], or [[equal]]."
see (`interface Comparable`)
by ("Gavin")
shared abstract class Comparison(shared actual String string) 
        of larger | smaller | equal satisfies Immutable {
    "The reversed value of this comparison."
    shared formal Comparison reversed;
}

"The value is exactly equal to the given value."
shared object equal extends Comparison("equal") {
    reversed => this;
}

"The value is smaller than the given value."
shared object smaller extends Comparison("smaller") {
    reversed => larger;
}

"The value is larger than the given value."
shared object larger extends Comparison("larger") {
    reversed => smaller;
}
