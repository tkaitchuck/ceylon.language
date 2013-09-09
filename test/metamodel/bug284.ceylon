import ceylon.language.model { ... }

class Bug284(){
    shared class Inner(Integer i){}
    shared String method(Integer i){ return "";}
    shared Integer attr = 2;
}

void bug284() {
    value b = `Bug284`;
    assert(is Attribute<Bug284, Integer> attr = b.getAttribute("attr"));
    assert(exists value method = b.getMethod("method"));
    print(type(method));
    assert(is Method<Bug284, String,[Integer]> method);
    assert(is MemberClass<Bug284.Inner, [Integer]> klass = b.getClassOrInterface("Inner"));
}