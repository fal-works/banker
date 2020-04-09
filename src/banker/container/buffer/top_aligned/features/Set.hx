package banker.container.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Set<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Set<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Set` **/
	public inline function add(element: T): Void
		StackExtension.push(this, element);

	/** @see `banker.container.interfaces.Set` **/
	public inline function addFromVector(otherVector: VectorReference<T>): Void
		StackExtension.pushFromVector(this, otherVector);

	/** @see `banker.container.interfaces.Set` **/
	public inline function findFirst(
		predicate: (element: T) -> Bool,
		defaultValue: T
	): T { @:nullSafety(Off) // HACK: Don't know why but this seems to be necessary
		return SetExtension.findFirst(this, predicate, defaultValue);
	}

	/** @see `banker.container.interfaces.Set` **/
	public inline function remove(element: T): Bool
		return SetExtension.remove(this, element);

	/**
		@see `banker.container.interfaces.Set`
		@see `banker.container.buffer.top_aligned.SetExtension`
	**/
	public inline function removeAll(predicate: (element: T) -> Bool): Bool
		return SetExtension.removeAll(this, predicate);

	/** @see `banker.container.interfaces.Set` **/
	public inline function has(element: T): Bool
		return SetExtension.has(this, element);

	/** @see `banker.container.interfaces.Set` **/
	public inline function hasAny(predicate: (element: T) -> Bool): Bool
		return SetExtension.hasAny(this, predicate);

	/** @see `banker.container.interfaces.Set` **/
	public inline function count(predicate: (element: T) -> Bool): Int
		return SetExtension.count(this, predicate);

	/** @see `banker.container.interfaces.Set` **/
	public inline function countAll<S>(
		grouperCallback: (element: T) -> S
	): banker.map.ArrayMap<S, Int>
		return SetExtension.countAll(this, grouperCallback);
}
