package banker.container.buffer.top_aligned.features;

#if !banker_generic_disable
@:generic
#end
@:ripper_verified
class Indexed<T>
	extends TopAlignedBuffer<T>
	implements banker.container.interfaces.Indexed<T>
	implements ripper.Spirit {
	/** @see `banker.container.interfaces.Indexed` **/
	public inline function get(index: UInt): T
		return IndexedExtension.get(this, index);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function set(index: UInt, value: T): T
		return IndexedExtension.set(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function insertAt(index: UInt, value: T): T
		return IndexedExtension.insertAt(this, index, value);

	/** @see `banker.container.interfaces.Indexed` **/
	public inline function removeAt(index: UInt): T
		return IndexedExtension.removeAt(this, index);
}
