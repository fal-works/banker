package banker.container.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
class Indexed<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Indexed<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Indexed` **/
	public inline function get(index: Int): T
		return IndexedExtension.get(this, index);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function set(index: Int, value: T): T
		return IndexedExtension.set(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function insertAt(index: Int, value: T): T
		return IndexedExtension.insertAt(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function removeAt(index: Int): T
		return IndexedExtension.removeAt(this, index);
}
