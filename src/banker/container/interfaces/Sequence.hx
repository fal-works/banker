package banker.container.interfaces;

interface Sequence<T> {
	function forEach(callback: T->Void): Void;
}
