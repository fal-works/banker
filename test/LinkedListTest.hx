import banker.link.SinglyLinkable;

class SNode implements SinglyLinkable {
	public final value: Int;
	public function new(value: Int) {
		this.value = value;
	}
}

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

	public static final all = testCaseGroup([
		_basic,
		_traverse
	]);
}
