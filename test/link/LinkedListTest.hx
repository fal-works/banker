package link;

class LinkedListTest {
	static function basic() {
		describe("This goes without error.");

		final first = new SNode(1);
		final second = new SNode(2);
		final third = new SNode(3);

		first.linkTo(second);
		second.linkTo(third);

		var sum = 0;
		sum += first.value;
		print('${first.value} ');

		var current = first.next;
		while (current.isSome()) {
			final node = current.unwrap();
			sum += node.value;
			current = node.next;
			print('${node.value} ');
		}

		assert(sum == 6);
		println("");
	}

	static final _basic = testCase(basic, Ok);

	static function traverse() {
		describe("This goes without error.");

		final first = new SNode(1);
		final second = new SNode(2);
		final third = new SNode(3);

		first.linkTo(second);
		second.linkTo(third);

		var sum = 0;

		first.traverse(node -> {
			sum += node.value;
			print('${node.value} ');
		});

		assert(sum == 6);
		println("");
	}

	static final _traverse = testCase(traverse, Ok);

	static function queue() {
		describe("This goes without error.");

		final queue = new SQueue();
		queue.enqueue(new SNode(10));
		queue.enqueue(new SNode(1));
		queue.enqueue(new SNode(3));
		queue.enqueue(new SNode(5));
		final removed = queue.dequeue();
		final removedValue = removed.value;
		assert(removedValue == 10);

		var sum = 0;

		queue.forEach(node -> {
			sum += node.value;
			print('${node.value} ');
		});

		assert(sum == 9);
		println("");
	}

	static final _queue = testCase(queue, Ok);

	public static final all = testCaseGroup([
		_basic,
		_traverse,
		_queue
	]);
}
