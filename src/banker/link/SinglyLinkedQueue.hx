package banker.link;

#if macro
import banker.link.macro.SinglyLinkedQueueMacro;

class SinglyLinkedQueue {
	/**
		The entry point of build macro for singly linked queue classes.
		@param linkableClass Any class that implements `banker.link.SinglyLinkable`.
	**/
	public static macro function from(linkableClass: Expr): Null<Fields>
		return SinglyLinkedQueueMacro.create(linkableClass);
}
#else
class SinglyLinkedQueue {}
#end
