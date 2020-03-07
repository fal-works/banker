package banker.watermark;

import sneaker.tag.interfaces.Tagged;

/**
	Extension used for `banker.common.LimitedCapacityBuffer`.

	This can also be used for any data collection class that is `Tagged`
	and	can provide its usage ratio in some way, so that the class can be
	included in the watermark info that `banker.watermark.Watermark` provides.
**/
class TaggedExtension {
	/**
		Sets a mapping from `name` to `usageRatio`, only if `usageRatio` is
		greater than the value that was previously set for `name`.

		@param instance Any `Tagged` instance. The tag name is used
		as an identification name of the data collection object.
		The name does not have to be unique for each instance;
		It can also be a name for an instance group.
	**/
	public static inline function setWatermark(
		instance: Tagged,
		usageRatio: Percentage
	): Void {
		#if banker_watermark_enable
		final tag = instance.tag;

		if (!WatermarkSettings.excludeTagBits(tag.bits))
			Watermark.data.set(tag.name, usageRatio);
		#end
	}
}
