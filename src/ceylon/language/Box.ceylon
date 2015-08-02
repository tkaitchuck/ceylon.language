"A datastructure to hold a single item."
shared mutable class Box<opaque X>(variable X item) {
	
	shared X set(X newItem) {
		X oldItem = item;
		item = newItem;
		return oldItem;
	}
	
	shared X get() {
		return item;
	}
}