import ceylon.language.meta { modules }

shared mutable class BugC1201Person(name) {
    variable shared String name;
    string=>name;
}

@test
shared void bugC1201() {
    value p = `BugC1201Person`;
    p("Me");
    value person = BugC1201Person("Gavin");
    value n = `BugC1201Person.name`;
    n(person).set("Stef");
    assert(n(person).get() == "Stef");
}
