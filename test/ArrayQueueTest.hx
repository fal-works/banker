package;

import banker.container.ArrayQueue;

class ArrayQueueTest {
	static function enqueue() {
		describe("none");
		final queue = new ArrayQueue<String>(5);
		queue.enqueue("AAA");
		queue.enqueue("BBB");
		assert(queue.toString() == "AAA, BBB");
	}

	static final _enqueue = testCase(enqueue, Ok);

	static function dequeue() {
		describe("none");
		final queue = new ArrayQueue<String>(5);
		queue.enqueue("AAA");
		queue.enqueue("BBB");
		final removed = queue.dequeue();
		assert(removed == "AAA");
	}

	static final _dequeue = testCase(dequeue, Ok);

	static function ring() {
		describe("none");
		final queue = new ArrayQueue<String>(3);
		queue.enqueue("AAA");
		queue.enqueue("BBB");
		queue.dequeue();
		queue.enqueue("CCC");
		queue.enqueue("DDD");
		assert(queue.toString() == "BBB, CCC, DDD");
	}

	static final _ring = testCase(ring, Ok);

	public static final all = testCaseGroup([
		_enqueue,
		_dequeue,
		_ring
	]);
}
