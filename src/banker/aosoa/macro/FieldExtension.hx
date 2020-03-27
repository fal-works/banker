package banker.aosoa.macro;

#if macro
import haxe.macro.Context;

/**
	Functions for static extension used in `banker.aosoa.macro`.
**/
class FieldExtension {
	public static function createMetadataMap(_this: Field) {
		final map:MetadataMap = {
			useEntity: false,
			factory: None,
			hidden: false,
			swap: false,
			chunkLevel: false
		};

		final metadataArray = _this.meta;
		if (metadataArray == null) return map;

		for (i in 0...metadataArray.length) {
			final metadata = metadataArray[i];
			switch (metadata.name) {
				case MetadataNames.useEntity:
					map.useEntity = true;
				case MetadataNames.hidden:
					map.hidden = true;
				case MetadataNames.swap:
					map.swap = true;
				case MetadataNames.chunkLevel:
					map.chunkLevel = true;
				case MetadataNames.factory:
					if (map.factory != None) {
						warn("Cannot add multiple factory functions", metadata.pos);
						break;
					}

					final parameters = metadata.params;

					if (parameters == null || parameters.length == 0) {
						warn("Function required", metadata.pos);
						break;
					}
					if (parameters.length >= 2) {
						warn("Too many parameters", metadata.pos);
						break;
					}

					map.factory = Some(parameters[0]);
			}
		}

		return map;
	}
}
#end
