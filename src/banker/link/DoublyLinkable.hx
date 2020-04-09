package banker.link;

/**
	Marker interface indicating that the class is a node of doubly linked list.
	By implementing this, some fields are automatically added.
**/
@:autoBuild(banker.link.macro.DoublyLinkableMacro.build())
interface DoublyLinkable {}
