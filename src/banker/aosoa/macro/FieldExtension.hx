package banker.aosoa.macro;

#if macro
using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using sneaker.macro.extensions.ExprExtension;

import haxe.macro.Type;
import haxe.macro.Context;
import sneaker.types.Maybe;

/**
	Functions for static extension used in `banker.aosoa.macro`.
**/
class FieldExtension {
	public static function createMetadataMap(_this: Field) {
		final map: MetadataMap = {
			useEntity: false,
			onSynchronize: false,
			onCompleteSynchronize: false,
			factory: Maybe.none(),
			factoryWithId: Maybe.none(),
			externalFactory: false,
			readOnly: false,
			hidden: false,
			swap: false,
			chunkLevel: false,
			chunkLevelFinal: false,
			chunkLevelFactory: Maybe.none()
		};

		final metadataArray = _this.meta;
		if (metadataArray == null) return map;

		for (i in 0...metadataArray.length) {
			final metadata = metadataArray[i];
			switch (metadata.name) {
				case MetadataNames.useEntity | MetadataNames.useEntity_:
					map.useEntity = true;
				case MetadataNames.onSynchronize | MetadataNames.onSynchronize_:
					map.onSynchronize = true;
				case MetadataNames.onCompleteSynchronize | MetadataNames.onCompleteSynchronize_:
					map.onCompleteSynchronize = true;
				case MetadataNames.externalFactory | MetadataNames.externalFactory_:
					map.externalFactory = true;
				case MetadataNames.readOnly | MetadataNames.readOnly_:
					map.readOnly = true;
				case MetadataNames.hidden | MetadataNames.hidden_:
					map.hidden = true;
				case MetadataNames.swap | MetadataNames.swap_:
					map.swap = true;
				case MetadataNames.chunkLevel | MetadataNames.chunkLevel_:
					map.chunkLevel = true;
				case MetadataNames.chunkLevelFinal | MetadataNames.chunkLevelFinal_:
					map.chunkLevelFinal = true;

				case MetadataNames.factory | MetadataNames.factory_:
					if (duplicateMetadata(map.chunkLevelFactory, metadata.pos)) break;
					final parameters = metadata.params;
					if (!hasOneParameter(parameters, metadata.pos)) break;
					final expression = macro @:privateAccess ${parameters[0]};
					map.factory = Maybe.from(expression);
					// Validate in ChunkVariableBuilder.createConstructorPiece() instead of here

				case MetadataNames.factoryWithId | MetadataNames.factoryWithId_:
					if (duplicateMetadata(map.chunkLevelFactory, metadata.pos)) break;
					final parameters = metadata.params;
					if (!hasOneParameter(parameters, metadata.pos)) break;
					final expression = parameters[0].privateAccess();
					map.factoryWithId = Maybe.from(expression);

				case MetadataNames.chunkLevelFactory | MetadataNames.chunkLevelFactory_:
					if (duplicateMetadata(map.chunkLevelFactory, metadata.pos)) break;
					final parameters = metadata.params;
					if (!hasOneParameter(parameters, metadata.pos)) break;
					final expression = parameters[0].privateAccess();
					if (!validateChunkLevelFactoryType(expression, chunkLevelFactoryType)) break;
					map.chunkLevelFactory = Maybe.from(expression);
			}
		}

		if (map.chunkLevelFinal || map.chunkLevelFactory.isSome())
			map.chunkLevel = true;

		return map;
	}

	static final chunkLevelFactoryType = (macro:(chunkCapacity: Int) -> Dynamic).toType();

	/**
		@return `true` if `registered` is already `Some<T>`. Otherwise `false` (also outputs warning log).
	**/
	static function duplicateMetadata(registered: Maybe<Dynamic>, position: Position) {
		return if (registered.isSome()) {
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

	static function validateChunkLevelFactoryType(expression: Expr, requiredType: Type): Bool {
		final type = Context.typeof(expression);
		return if (type.unify(requiredType)) {
			true;
		} else {
			warn(
				'Invalid type.\nWant: (chunkCapacity: Int) -> ?\nHave: ${type.toString()}',
				expression.pos
			);
			false;
		}
	}
}
#end
