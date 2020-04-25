package banker.link;

#if macro
import banker.link.macro.DoublyLinkedDequeMacro;

class DoublyLinkedDeque {
	/**
		The entry point of build macro for doubly linked deque classes.
		@param linkableClass Any class that implements `banker.link.DoublyLinkable`.
	**/
	public static macro function from(linkableClass: Expr): Null<Fields>
		return DoublyLinkedDequeMacro.create(linkableClass);
}
#else
class DoublyLinkedDeque {}
#end
