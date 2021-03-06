import ceylon.language.meta.model {...}

class Bug708 {
    shared new nnew() {}
    shared class Member {
        shared new nnew() {}
    }
}

@test
shared void bug708() {
    Constructor<Bug708, []> constructor1 = `Bug708.nnew`;
    Class<Bug708> clazz = constructor1.container;
    MemberClassConstructor<Bug708, Bug708.Member, []> constructor2 = `Bug708.Member.nnew`;
    MemberClass<Nothing,Bug708.Member> clazz2 = constructor2.container;
}
