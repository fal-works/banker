package banker.container.interfaces;

interface Sequence<T> {
	function forEach(callback: T->Void): Void;
	function filter(predicate: T->Bool): Vector<T>;
	function map<S>(callback: T->S): Vector<S>;
}
