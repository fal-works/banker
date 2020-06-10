package banker.types;

/**
	A set of unduplicated elements.

	This is a naive implementation based on `Map<K, Bool>` and may not be efficient in some cases.
**/
@:notNull @:forward(exists, remove, clear)
abstract NaiveSet<K>(Map<K, Bool>) {
	/**
		Creates a Set.
	**/
	public extern inline function new()
		this = new Map<K, Bool>();

	/**
		Adds `element` to `this` Set.
	**/
	public extern inline function add(element:K): Void
		this.set(element, true);

	/**
		@return `Iterator` over the keys of `this` Set. The order is undefined.
	**/
	public extern inline function iterator():Iterator<K>
		return this.keys();

	/**
		@return Shallow copy of `this`.
	**/
	public extern inline function copy():NaiveSet<K>
		return cast this.copy();

	/**
		@return A `String` representation of `this`.
	**/
	public inline function toString():String
		return toArray().toString();

	/**
		Alias for `exists()`.
	**/
	public extern inline function has(element:K):Bool
		return this.exists(element);

	/**
		@return An `Array` of the keys of `this` Set.
	**/
	public inline function toArray():Array<K>
		return [for (element in this.keys()) element];
}
