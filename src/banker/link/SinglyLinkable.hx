package banker.link;

/**
	Marker interface indicating that the class is a node of singly linked list.
	By implementing this, some fields are automatically added.
**/
@:autoBuild(banker.link.macro.SinglyLinkableMacro.build())
interface SinglyLinkable {}
