package banker.link.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sneaker.macro.Types;
import sneaker.macro.ContextTools;
import sneaker.macro.extensions.FieldExtension.isNew;
import banker.link.macro.Utility.*;

using haxe.macro.TypeTools;
using banker.array.ArrayFunctionalExtension;

class DoublyLinkableMacro {
	/**
		The entry point of build macro for `DoublyLinkable` interface.
	**/
	static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();
		final localClassPathStringFull = '${localClass.module}.${localClass.name}';
		final localClassComplexType = Context.getType(localClassPathStringFull)
			.toComplexType();

		final nextNodeVariableName = "next";
		final previousNodeVariableName = "previous";

		final classDef = macro class DoublyLinkableBase {
			/**
				Interconnects `former` and `latter`.
			**/
			public static inline function link(
				former: $localClassComplexType,
				latter: $localClassComplexType
			): Void {
				former.$nextNodeVariableName = latter;
				latter.$previousNodeVariableName = former;
			}

			/**
				Disconnects `former` and `latter` (which should be interconnected) from each other, i.e.
				- Clears the link from `former` to its next node.
				- Clears the link from `latter` to its previous node.
			**/
			public static inline function unlink(
				former: $localClassComplexType,
				latter: $localClassComplexType
			): Void {
				former.$nextNodeVariableName = sneaker.types.Maybe.from(null);
				latter.$previousNodeVariableName = sneaker.types.Maybe.from(null);
			}

			/**
				The next node linked from `this`.
			**/
			public var $nextNodeVariableName:sneaker.types.Maybe<$localClassComplexType>;

			/**
				The previous node linked from `this`.
			**/
			public var $previousNodeVariableName:sneaker.types.Maybe<$localClassComplexType>;

			/**
				Interconnects `previous` and `this`.
			**/
			public inline function linkFrom(previous: $localClassComplexType): Void
				link(previous, this);

			/**
				Interconnects `this` and `next`.
			**/
			public inline function linkTo(next: $localClassComplexType): Void
				link(this, next);

			/**
				Disconnects `this` and its next node (if exists) from each other.
			**/
			public inline function unlinkNext(): Void {
				final next = this.$nextNodeVariableName;
				if (next.isSome()) unlink(this, next.unwrap());
			}

			/**
				Disconnects `this` and its previous node (if exists) from each other.
			**/
			public inline function unlinkPrevious(): Void {
				final previous = this.$previousNodeVariableName;
				if (previous.isSome()) unlink(previous.unwrap(), this);
			}

			/**
				Runs `callback` for each node in the list starting from `this` until the last node.
			**/
			public inline function traverse(callback: (node: $localClassComplexType) -> Void): Void {
				callback(this);

				var current = this.$nextNodeVariableName;
				while (current.isSome()) {
					final node = current.unwrap();
					callback(node);
					current = node.$nextNodeVariableName;
				}
			}

			/**
				Runs `callback` for each node in the list starting from `this` until the first node.
			**/
			public inline function traverseBackwards(callback: (node: $localClassComplexType) -> Void): Void {
				callback(this);

				var current = this.$previousNodeVariableName;
				while (current.isSome()) {
					final node = current.unwrap();
					callback(node);
					current = node.$previousNodeVariableName;
				}
			}

			/**
				Clears the links from `this`.
				Note that this does not affect the next/previous nodes of `this`.
			**/
			public inline function reset(): Void {
				this.$previousNodeVariableName = sneaker.types.Maybe.from(null);
				this.$nextNodeVariableName = sneaker.types.Maybe.from(null);
			}

			/**
				Removes `this` from the list to which it belongs without dividing the whole list, i.e.
				interconnects the previous/next nodes of `this` and then calls `this.reset()`.
			**/
			public inline function removeSplice(): Void {
				final previous = this.$previousNodeVariableName;
				final next = this.$nextNodeVariableName;

				if (previous.isSome()) previous.unwrap().$nextNodeVariableName = next;
				if (next.isSome()) next.unwrap().$previousNodeVariableName = previous;

				this.reset();
			}
		};

		final buildFields = Context.getBuildFields();
		final constructor = buildFields.removeFirst(
			isNew,
			createDefaultConstructor()
		);
		switch (constructor.kind) {
			case FFun(func):
				func.expr = macro $b{
					[
						func.expr,
						macro this.$nextNodeVariableName = sneaker.types.Maybe.none(),
						macro this.$previousNodeVariableName = sneaker.types.Maybe.none()
					]
				}
			default:
		}
		buildFields.push(constructor);

		return buildFields.concat(classDef.fields);
	}
}
#end
