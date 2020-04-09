package banker.watermark;

#if banker_watermark_enable
using StringTools;

import banker.map.ArrayOrderedMap;
import sneaker.string_buffer.StringBuffer;
#end

/**
	@see `Watermark.data` from which this class is used.
	@see `ConcreteWatermarkData` for the actual implementation.
**/
@:allow(banker.watermark.WatermarkSettings)
class WatermarkData {
	public static function createNull(): WatermarkData
		return new NullWatermarkData();

	#if banker_watermark_enable
	static function createConcrete(): WatermarkData
		return new ConcreteWatermarkData();
	#end

	/**
		@return The recorded maximum usage ratio of the data collection objects
		which have any tag with `name`.
	**/
	public function get(name: String): Percentage
		return Percentage.none;

	/**
		@see `banker.watermark.TaggedExtension.setWatermark()`
		(from which this method is called)
	**/
	public function set(name: String, usageRatio: Percentage): Void {}

	/**
		Prints all data.
	**/
	public function print(): Void {}

	/**
		Resets all data.
	**/
	public function reset(): Void {}

	/**
		@see `WatermarkSettings.usageDataMapBits`
	**/
	function setUsageDataMapBits(bits: Int): Int
		return WatermarkSettings.usageDataMapBits;
}

private class NullWatermarkData extends WatermarkData {
	public function new() {}

	#if banker_watermark_enable
	@:access(banker.watermark.Watermark)
	override public function set(name: String, usageRatio: Percentage): Void {
		final concreteData = WatermarkData.createConcrete();

		// This will also be internally used in concreteData.set()
		Watermark.data = concreteData;

		concreteData.set(name, usageRatio);
	}
	#end
}

#if banker_watermark_enable
private class ConcreteWatermarkData extends WatermarkData {
	static inline final mapExpandThreshold = Percentage.fromInt(90); // 90%
	static inline final mapExpandFactor = 1.5;
	static inline final mapInitialCapacity = 32;
	static inline final mapName = "Watermark map";

	static final newValueIsGreater = function(
			key: String,
			oldValue: Percentage,
			newValue: Percentage
	) {
		return (oldValue : Percentage) < (newValue : Percentage);
	};

	/**
		The map that actually stores data about the maximum usage ratio for each data collection object.
		This is automatically replaced for expanding the capacity when it is getting full.
	**/
	public var map = new ArrayOrderedMap<String, Percentage>(mapInitialCapacity).newTag(
		mapName,
		WatermarkSettings.usageDataMapBits
	);

	var maxNameLength = 0;

	public function new() {}

	override public inline function get(name: String): Percentage
		return map.getOr(name, Percentage.none);

	/** @inheritdoc **/
	override public function set(name: String, usageRatio: Percentage): Void {
		final registeredData = map.getOr(name, Percentage.none);

		if (registeredData != Percentage.none)
			map.setIf(name, usageRatio, newValueIsGreater);
		else
			registerName(name, usageRatio);
	}

	/** @inheritdoc **/
	override public function print(): Void {
		final buffer = new StringBuffer();

		final alignmentPosition = maxNameLength + 2;

		map.forEach((name, usageData) -> {
			buffer.lf();
			buffer.add(name.rpad(" ", alignmentPosition));
			(usageData : Percentage).addStringTo(buffer);
		});

		WatermarkSettings.logType.print(buffer.toString());
	}

	/** @inheritdoc **/
	override public function reset(): Void
		map.clearPhysical();

	/** @inheritdoc **/
	override function setUsageDataMapBits(bits: Int): Int {
		map.newTag(map.tag.name, bits);
		return bits;
	}

	inline function expandMap(): Void
		map = map.cloneAsOrderedMap(Std.int(mapExpandFactor * map.capacity));

	inline function updateMaxNameLength(newLength: Int): Void
		if (maxNameLength < newLength) maxNameLength = newLength;

	inline function registerName(name: String, initialValue: Percentage) {
		map.set(name, initialValue);

		if (map.getUsageRatio() > mapExpandThreshold) expandMap();

		updateMaxNameLength(name.length);
	}
}
#end
