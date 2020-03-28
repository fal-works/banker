package banker.aosoa.macro;

#if macro
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;

import haxe.ds.Option;
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
			chunkLevel: false,
			chunkLevelFinal: false,
			chunkLevelFactory: None,
			onSynchronize: false
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
				case MetadataNames.chunkLevelFinal:
					map.chunkLevelFinal = true;
				case MetadataNames.onSynchronize:
					map.onSynchronize = true;

				case MetadataNames.factory:
					if (duplicateMetadata(map.chunkLevelFactory, metadata.pos)) break;
					final parameters = metadata.params;
					if (!hasOneParameter(parameters, metadata.pos)) break;
					final expression = parameters[0];
					if (!validateFactoryType(expression)) break;
					map.factory = Some(expression);

				case MetadataNames.chunkLevelFactory:
					if (duplicateMetadata(map.chunkLevelFactory, metadata.pos)) break;
					final parameters = metadata.params;
					if (!hasOneParameter(parameters, metadata.pos)) break;
					final expression = parameters[0];
					if (!validateChunkLevelFactoryType(expression)) break;
					map.chunkLevelFactory = Some(expression);
			}
		}

		if (map.chunkLevelFinal || map.chunkLevelFactory != None)
			map.chunkLevel = true;

		return map;
	}

	static final factoryType = (macro: () -> Dynamic).toType();
	static final chunkLevelFactoryType = (macro: (chunkCapacity: Int) -> Dynamic).toType();

	/**
		@return `true` if `registered` is already `Some<T>`. Otherwise `false` (also outputs warning log).
	**/
	static function duplicateMetadata(registered: Option<Dynamic>, position: Position) {
		return if (registered != None) {
			warn("Duplicate metadata", position);
			true;
		} else false;
	}

	/**
		@return `true` if `parameters` has just one element. Otherwise `false` (also outputs warning log).
	**/
	static function hasOneParameter(parameters: Null<Array<Expr>>, position: Position) {
		return if (parameters == null || parameters.length == 0) {
			warn("Parameter required", position);
			false;
		} else if (parameters.length >= 2) {
			warn("Too many parameters", position);
			false;
		} else true;
	}

	static function validateFactoryType(expression: Expr): Bool {
		final type = Context.typeof(expression);
		return if (Context.typeof(expression).unify(factoryType)) {
			true;
		} else {
			warn('Invalid type.\nWant: () -> ?\nHave: ${type.toString()}', expression.pos);
			false;
		}
	}

	static function validateChunkLevelFactoryType(expression: Expr): Bool {
		final type = Context.typeof(expression);
		return if (type.unify(chunkLevelFactoryType)) {
			true;
		} else {
			warn('Invalid type.\nWant: (chunkCapacity: Int) -> ?\nHave: ${type.toString()}', expression.pos);
			false;
		}
	}
}
#end
