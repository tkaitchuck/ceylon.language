//Array tests
@test
shared void testArrays() {
    check(Array{1,2,3}.rest==[2,3], "Array.rest");
    check(Array{}.size==0, "array size 0");
    value a1 = Array{1};
    check(a1.size==1, "array.size");
    check(a1[0] exists, "array[0]");
    check(!a1.empty, "array.empty");
    check(a1.hash==32, "array.hash is ``a1.hash`` instead of 32");
    a1.set(0,10);
    if (exists i=a1[0]) {
        check(i==10, "array.set");
    } else { fail("array.set"); }
    value a2=Array{1,2,3};
    value a3=Array([1,2,3]);
    check(a2==a3, "array.equals");
    check(a2.size==a3.size, "array.size");
    a2.set(0,10);
    if (exists i=a2[0]) {
        check(i==10, "array.set 2");
    } else { fail("array.set 2"); }
    value a4 = arrayOfSize(5, ".");
    check(a4.size == 5, "makeArray 1");
    if (exists i=a4[4]) {
        check(i==".", "makeArray 2");
    } else { fail("makeArray 2"); }
    value a5 = arrayOfSize(3, 0);
    check(a5.size == 3, "makeArray 3");
    if (exists i=a5[2]) {
        check(i==0, "makeArray 4");
    } else { fail("makeArray 4"); }
    value a6 = Array<Integer?>{1};
    a6.set(0,null);
    if (exists i=a6[0]) {
        fail("array.set (null)");
    }
    value a7=Array<Integer?>{1,2,3};
    a7.set(0,null);
    if (exists i=a7[0]) {
        fail("array.set (null) 2");
    }
    check(Array{1,2,3}.reversed==Array{3,2,1}, "Array.reversed");
    
    for (ii in 0:3) {
        a3.set(ii, 5);
    }
    
    a2.copyTo(a3);
    check(a3==Array{ 10, 2, 3 }, "Array.copyTo() expected 10,2,3 got ``a3``");
    
    for (ii in 0:3) {
        a3.set(ii, 5);
    }
    
    a2.copyTo(a3, 1, 0, 1);
    check(a3==Array{ 2, 5, 5 }, "copyTo(1, 0, 1)");
    
    for (ii in 0:3) {
        a3.set(ii, 5);
    }
    
    a2.copyTo(a3, 1, 1, 1);
    check(a3==Array{ 5, 2, 5 }, "copyTo(1, 1, 1)");

    //copy to itself
    value a8=Array{1,2,3,null,null};
    a8.copyTo(a8,1,2,2);
    check(a8==Array{1,2,2,3,null}, "copyTo self 1 expected 1,2,2,3,null got ``a8``");
    value a9=Array{"a","b","c",null,null};
    a9.copyTo(a9,1,2,2);
    check(a9==Array{"a","b","b","c",null}, "copyTo self 2 expected a,b,b,c,null got ``a9``");
    a8.set(4,4);
    a8.copyTo(a8,2,1);
    check(a8==Array{1,2,3,4,4}, "copyTo self 3 expected 1,2,3,4,4 got ``a8``");
    a9.set(4,"d");
    a9.copyTo(a9,2,1);
    check(a9==Array{"a","b","c","d","d"}, "copyTo self 4 expected a,b,c,d,d got ``a9``");
    //native array for JVM
    value a10=Array{1,2,3,4,5};
    a10.copyTo(a10,1,2,3);
    check(a10==Array{1,2,2,3,4}, "copyTo self 5 expected 1,2,2,3,4 got ``a10``");
    value a11=Array{1,2,3,4,5};
    a11.copyTo(a11,2,1);
    check(a11==Array{1,3,4,5,5}, "copyTo self 6 expected 1,3,4,5,5 got ``a11``");
    
    check(Array{1,2,3}.take(-1).size==0, "Array take -1 ``Array{1,2,3}.take(-1)``");
    check(Array{1,2,3}.take(0).size==0, "Array take 0 ``Array{1,2,3}.take(0)``");
    check("{}"==Array{1,2,3}.take(0).string, "Array take 0 ``Array{1,2,3}.take(0)``");
    check("{ 1 }"==Array{1,2,3}.take(1).string, "Array take 1 ``Array{1,2,3}.take(1)``");
    check("{ 1, 2 }"==Array{1,2,3}.take(2).string, "Array take 2 ``Array{1,2,3}.take(2)``");
    check("{ 1, 2, 3 }"==Array{1,2,3}.take(3).string, "Array take 3 ``Array{1,2,3}.take(3)``");
    check("{ 1, 2, 3 }"==Array{1,2,3}.take(4).string, "Array take 4 ``Array{1,2,3}.take(4)``");
    
    check([1, 2, 3]==Array{1,2,3}.skip(-1), "Array skip -1 ``Array{1,2,3}.skip(-1)``");
    check([1, 2, 3]==Array{1,2,3}.skip(0), "Array skip 0 ``Array{1,2,3}.skip(0)``");
    check("{ 2, 3 }"==Array{1,2,3}.skip(1).string, "Array skip 1 ``Array{1,2,3}.skip(1)``");
    check("{ 3 }"==Array{1,2,3}.skip(2).string, "Array skip 2 ``Array{1,2,3}.skip(2)``");
    check("{}"==Array{1,2,3}.skip(3).string, "Array skip 3 ``Array{1,2,3}.skip(3)``");
    check("{}"==Array{1,2,3}.skip(4).string, "Array skip 4 ``Array{1,2,3}.skip(4)``");
    
    try {
        Array{1,2,3}.by(-1);
        fail("Array by -1");
    } catch (AssertionError e) {
        
    }
    try {
        Array{1,2,3}.by(0);
        fail("Array by 0");
    } catch (AssertionError e) {
        
    }
    check([1, 2, 3]==Array{1,2,3}.by(1), "Array by 1 ``Array{1,2,3}.by(1)``");
    check("{ 1, 3 }"==Array{1,2,3}.by(2).string, "Array by 2 ``Array{1,2,3}.by(2)``");
    check("{ 1 }"==Array{1,2}.by(2).string, "Array by 2 (again) ``Array{1,2,3}.by(2)``");
    check("{ 1 }"==Array{1,2,3}.by(3).string, "Array by 3 ``Array{1,2,3}.by(3)``");
    check("{ 1 }"==Array{1,2,3}.by(4).string, "Array by 4 ``Array{1,2,3}.by(4)``");
    
    check("{ 2, 4, 6 }"==Array{1,2,3,4,5,6}.skip(1).by(2).string, "Array skip 1 by 2");
    check("{ 1, 3, 5 }"==Array{1,2,3,4,5,6}.take(5).by(2).string, "Array take 5 by 2");
    check("{ 2, 4 }"==Array{1,2,3,4,5,6}.take(5).skip(1).by(2).string, "Array take 5 skip 1 by 2");
    check("{ 3 }"==Array{1,2,3,4,5,6}.by(2).take(2).skip(1).string, "Array by 2 take 2 skip 1");
    
    value ae = AssertionError("");
    value assertionErrors = arrayOfSize<AssertionError>(2, ae);
    value assertionErrors2 = Array<AssertionError>([ae, ae]);
    value throwables = arrayOfSize<Throwable>(2, ae);
    value throwables2 = Array<Throwable>([ae, ae]);
    check(assertionErrors == assertionErrors2, "assertionErrors == assertionErrors2");
    check(throwables == throwables2, "throwables == throwables2");
    check(assertionErrors == throwables, "assertionErrors == throwables");
    check(assertionErrors2 == throwables2, "assertionErrors2 == throwables2");
    check(throwables.getFromFirst(100) is Null, "Array.getFromFirst");
    
    check((Array("helloworld").getFromLast(0) else ' ')=='d', "array getFromLast(0)");
    check((Array("helloworld").getFromLast(1) else ' ')=='l', "array getFromLast(1)");
    check((Array("helloworld").getFromLast(9) else ' ')=='h', "array getFromLast(8)");
    check(!Array("helloworld").getFromLast(-1) exists, "array getFromLast(-1)");
    check(!Array("helloworld").getFromLast(10) exists, "array getFromLast(9)");
    
    check(Array("hello")==[*"hello"], "sanity");
    check(Array("hello").size==5, "sanity");
    
    check(Array("hello")[0:4]==[*"hell"], "array segment 1");
    check(Array("hello")[-1:2]==['h'], "array segment 2");
    check(Array("hello")[1:0]==[], "array segment 3");
    check(Array("hello")[-1:1]==[], "array segment 4");
    check(Array("hello")[5:1]==[], "array segment 5");
    
    check(Array("hello")[0..3]==[*"hell"], "array span 1");
    check(Array("hello")[-1..0]==['h'], "array span 2");
    check(Array("hello")[1..-1]==['e','h'], "array span 3");
    check(Array("hello")[1..1]==['e'], "array span 4");
    check(Array("hello")[0..0]==['h'], "array span 5");
    check(Array("hello")[-1..-1]==[], "array span 6");
    check(Array("hello")[5..6]==[], "array span 7");
    check(Array("hello")[5..4]==['o'], "array span 8");
    
    check(Array{}[-1:2]==[], "empty array segment");
    check(Array{}[-1..2]==[], "empty array span");
    
    check(Array([1..3])==[1..3], "array from range");
    check(Array(["hello",0,"world"])==["hello",0,"world"], "array from tuple");
    check(Array([for (i in 1..3) i.character])==[for (i in 1..3) i.character], "array from sequence");
    
    check(Array { 4,1,3,2 }.sort(byIncreasing((Integer e) => e))==[1,2,3,4], "integer array sort");
    check(Array {"world", "hello", "" }.sort(byIncreasing((String e) => e))==["", "hello", "world"], "string array sort");
    check(Array {"Hello", null, "World"}.coalesced.sequence() == {"Hello", "World"}.sequence(), "Array.coalesced");

    //refined methods
    check(if (exists trm1=Array{1,2,3,4}.find((e)=>e>2)) then trm1==3 else false, "Array.find");
    check(if (exists trm2=Array{1,2,3,4}.findLast((e)=>e<3)) then trm2==2 else false, "Array.findLast");
    check(Array{1,2,3,4}.any((e)=>e>2), "Array.any 1");
    check(!Array{1,2,3,4}.any((e)=>e<1), "Array.any 2");
    check(Array{1,2,3,4}.every((e)=>0<e<5), "Array.every 1");
    check(!Array{1,2,3,4}.every((e)=>e<4), "Array.every 2");
    check(if (exists trm3=Array{1,2,3,4}.reduce((Integer e,Integer p)=>e+p)) then trm3==10 else false, "Array.reduce");
    value testEach=Array{TestEach(),TestEach(),TestEach()};
    testEach.each((e)=>e.set());
    check(testEach.every((e)=>e.ok), "Array.each");

    //native methods 2015-04-07
    value a12 = Array { 1, 2, 3, 2, 1, null, 5, null, 7 };
    if (exists loc0 = a12.locate((e) => e>1)) {
        Object oc0=loc0;
        check(oc0 is Integer->Integer?, "Array.locate 2");
        check(loc0 == 1->2, "Array.locate 3");
    } else {
        fail("Array.locate 1");
    }
    check(!a12.locate((e) => e>7) exists, "Array.locate 4");
    if (exists loc1 = a12.locateLast((e) => e.even)) {
        Object oc1=loc1;
        check(oc1 is Integer->Integer?, "Array.locateLast 2");
        check(loc1 == 3->2, "Array.locateLast 3");
    } else {
        fail("Array.locateLast 1");
    }
    check(!a12.locateLast((e)=>e<1) exists, "Array.locateLast 4");
    if (exists o0=a12.firstOccurrence(null)) {
        check(o0==5, "Array.firstOccurrence 2");
    } else {
        fail("Array.firstOccurrence 1");
    }
    check(!a12.firstOccurrence(0) exists, "Array.firstOccurrence 3");
    if (exists o1=a12.lastOccurrence(null)) {
        check(o1==7, "Array.lastOccurrence 2");
    } else {
        fail("Array.lastOccurrence 1");
    }
    check(!a12.lastOccurrence(0) exists, "Array.lastOccurrence 3");
    check(a12.occurs(5), "Array.occurs 1");
    check(!a12.occurs(4), "Array.occurs 2");
    /*check(a12.lookup(6).key, "Array.lookup 1");
    check(a12.lookup(6).item exists, "Array.lookup 2");
    check(a12.lookup(5).key, "Array.lookup 3");
    check(!a12.lookup(5).item exists, "Array.lookup 4");
    check(!a12.lookup(9).key, "Array.lookup 5");
    check(!a12.lookup(9).item exists, "Array.lookup 6");*/

    //constructor
    value a13=Array.ofSize(5,1);
    check(a13.size==5, "Array.ofSize 1");
    check(every { for (i in a13) i==1 }, "Array.ofSize 2");
    try {
        check(Array.ofSize(-1,1).size==0, "Array.ofSize(-1) should be empty");
    } catch (Throwable ex) {
        fail("Array.ofSize(-1)");
    }
    try {
        Array.ofSize(runtime.maxArraySize+1,1);
        fail("Array.ofSize(runtime.maxArraySize+1)");
    } catch (Throwable t) {
        check(t is AssertionError, "Array.ofSize 4");
    }
}
