package banker.container.interfaces;

interface Indexed<T> {
	/**
		@return The element at `index`.
	**/
	function get(index: UInt): T;

	/**
		Overwrites the element at `index` with `value`.
		`index` must be already used, i.e. cannot be equal or greater than current `this.size`.
		@return `value`
	**/
	function set(index: UInt, value: T): T;

	/**
		Inserts `value` to `this` at the position `index`.
		@return `value`
	**/
	function insertAt(index: UInt, value: T): T;

	/**
		Removes the element at the position `index`.
		@return The removed element.
	**/
	function removeAt(index: UInt): T;
}
