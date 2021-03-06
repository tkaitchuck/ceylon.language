shared void run() {
    testInlineExpressions();
    print("Equality, Comparable, clones");
    equality();
    comparables();
    bug1561();
    clones();
    //complex();
    print("Booleans, Numbers, Bytes, Characters, Strings");
    booleans();
    numbers();
    bytes();
    characters();
    strings();
    print("Lists, sequences, tuples, Array/Collection");
    lists();
    sequences();
    tuples();
    testArrays();
    print("Iterators, Entries, Ranges, spans & measures");
    iterators();
    entriesAndRanges();
    spanmeasures();
    testRange();
    testRecursiveRange();
    print("Types/satisfying interfaces, use-site variance");
    types();
    testSatisfaction();
    testUseSiteVariance();
    print("Exceptions");
    exceptions();
    print("Operators");
    operators();
    print("Miscellaneous");
    misc();
    switches();
    testSort();
    testConstructors();
    print("Map & Set tests");
    testMaps();
    testSets();
    print("Iterables & comprehensions");
    testIterables();
    comprehensions();
    print("Process, runtime, system, operatingSystem");
    testProcess();
    testRuntime();
    testSystem();
    testOperatingSystem();
    print("Callables & Curries");
    callables();
    testCurries();
    print("Resources");
    testResources();
    print("Predicates, destructuring");
    testPredicates();
    testDestructuring();
    print("Metamodel in default module");
    testMetamodelInDefaultModule();
    print("Native extensions");
    testNativeClassesAndObjects();

    // ATTENTION!
    // When you add new test methods here make sure they are "shared" and marked "@test"!

    results();
}

shared void runAndAssert() {
    run();
    print("There were ``failureCount`` failures (out of ``assertionCount`` assertions)");
    if (failureCount!=0) {
        throw Exception("There were ``failureCount`` failures (out of ``assertionCount`` assertions)");
    }
}

shared void runAndExit() {
    run();
    if (failureCount!=0) {
        print("There were ``failureCount`` failures (out of ``assertionCount`` assertions)");
    }
    process.exit(failureCount ==0 then 0 else 1);   
}

shared void test() { run(); }
