package banker.linker.interfaces;

// @formatter:off

interface Map<K, V>
	extends Convert<K, V>
	extends GetSet<K, V>
	extends Remove<K, V>
	extends Sequence<K, V>
	{}
