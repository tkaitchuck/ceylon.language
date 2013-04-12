shared interface ClassOrInterface<out Type> 
        of Class<Type,Nothing[]>|Interface<Type> 
        satisfies Declaration {
    shared formal Boolean typeOf(Anything instance);
    shared formal Boolean supertypeOf(ClassOrInterface<Anything> type);
    shared formal Boolean subtypeOf(ClassOrInterface<Anything> type);
    shared formal Class<Anything,Nothing[]> superclass;
    shared formal Interface<Anything>[] interfaces;
    shared formal Member<Subtype,Kind>[] members<Subtype,Kind>() 
            given Kind satisfies Declaration;
    shared formal Member<Subtype,Kind>[] annotatedMembers<Subtype,Kind,Annotation>() 
            given Kind satisfies Declaration;
}