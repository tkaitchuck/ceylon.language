"An [[Iterable]] that chains the elements of a sequence of 
 [[Iterable]]s."
see (`function Iterable.chain`)
by ("Gavin King")
class ChainedIterable<out Element,out Absent>
            (shared [{Element*}+] iterables) 
        satisfies Iterable<Element,Absent> 
        given Absent satisfies Null {
    iterator() => ChainedIterator(iterables);
}


"An [[Iterator]] that chains the elements of a sequence of 
 [[Iterable]]s."
see (`class ChainedIterable`)
by ("Enrique Zamudio", "Gavin King")
class ChainedIterator<out Element>([{Element*}+] iterables) 
        satisfies Iterator<Element> {
    
    value chain = iterables.iterator();
    variable Iterator<Element>? currentIterator = null;
    
    shared actual Element|Finished next() {
        if (exists i=currentIterator, 
            !is Finished current = i.next()) {
            return current;
        }
        else {
            while (true) {
                if (!is Finished next = chain.next()) {
                    value i = next.iterator();
                    currentIterator = i;
                    if (!is Finished current = i.next()) {
                        return current;
                    }
                }
                else {
                    currentIterator = null;
                    return finished;
                }
            }
        }
        
    }
}
