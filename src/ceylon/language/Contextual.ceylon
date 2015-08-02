import java.lang { ThreadLocal }

native
shared class Contextual<Element>() {
    
    native shared Element get();
    
    native shared class Using(Element|Element() newValue)
            satisfies Obtainable {
        shared actual void obtain() {}
        shared actual void release(Throwable? error) {}
    }
}

native("jvm")
shared class Contextual<Element>() {
    value threadLocal = ThreadLocal<Element>();
    
    native("jvm") shared Element get() {
        assert (exists result = threadLocal.get());
        return result;
    }
    
    native("jvm") shared class Using(Element|Element() newValue)
            satisfies Obtainable {
        value previous = Box<Element?>(null); 
        
        shared actual void obtain() {
            previous.set(threadLocal.get());
            if (is Element() newValue) {
                threadLocal.set(newValue());    
            } else {
                threadLocal.set(newValue);
            }
        }
        
        shared actual void release(Throwable? error) {
            if (exists p=previous.get()) {
                threadLocal.set(p);
            } else {
                threadLocal.remove();
            }
        }
    }
}

native("js")
shared mutable class Contextual<Element>() {
    variable Element? val = null;
    
    native("js") shared Element get() {
        assert (exists result = val);
        return result;
    }
    
    native("js") shared class Using(Element|Element() newValue)
            satisfies Obtainable {
        value previous = Box<Element?>(null); 
        
        shared actual void obtain() {
            previous.set(val);
            if (is Element() newValue) {
                val = newValue();    
            } else {
                val = newValue;
            }
        }
        
        shared actual void release(Throwable? error) {
            if (exists p=previous.get()) {
                val = p;
            } else {
                val = null;
            }
        }
    }
}
