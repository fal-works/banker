package banker.container.interfaces;

interface Queue<T> {
	function enqueue(value: T): Void;
	function dequeue(): T;
	// function peek(): T;
	// function pushFromVector(vector: VectorReference<T>): Void;
}
