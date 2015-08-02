import ceylon.language.meta { type }

mutable class Bug286() {
    shared variable String? nome = "Diego";
}

@test
shared void bug286() {
    value a = `Bug286`;
    value attribute = a.getAttribute<Bug286, String?>("nome");
    String s = type(attribute).string;
}