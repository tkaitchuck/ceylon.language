"The common interface all immutable objects implicetly implement.
 
 This allows refering to immutability as a type.
 For example you can have a method accept Comparable&Immutable"
by ("Tom Kaitchuck")
shared interface Immutable {}
shared alias BasicImmutableTypes => Immutable|Nothing|Null|[];
shared alias ImmutableMask => 
		BasicImmutableTypes |
		BasicImmutableTypes[] |
		Entry<BasicImmutableTypes,BasicImmutableTypes>;
