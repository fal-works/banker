package banker.link.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import sneaker.macro.Types;
import sneaker.macro.ContextTools;
import sneaker.macro.extensions.FieldExtension.isNew;
import banker.link.macro.Utility.*;

using haxe.macro.TypeTools;

class SinglyLinkedQueueMacro {
	/**
		The entry point of build macro for `SinglyLinkable` interface.
	**/
	public static function create(linkableTypeExpression: Expr): Null<Fields> {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();
		final localClassPathStringFull = '${localClass.module}.${localClass.name}';
		final localClassComplexType = Context.getType(localClassPathStringFull)
			.toComplexType();

		final resolved = ContextTools.resolveClassType(linkableTypeExpression, "banker.link.SinglyLinkable");
		if (resolved.isFailedWarn()) return null;
		final linkableType = resolved.unwrap().type.toComplexType();

		final classDef = macro class SinglyLinkedQueue {
			/**
				The top/oldest node in `this` queue.
			**/
			public var top: sneaker.types.Maybe<$linkableType>;

			/**
				The last/newest node in `this` queue.
			**/
			public var last: sneaker.types.Maybe<$linkableType>;

			/**
				Adds `element` as the last/newest element of `this`.
			**/
			public inline function enqueue(element: $linkableType): Void {
				final maybeLast = this.last;
				if (maybeLast.isSome()) {
					maybeLast.unwrap().linkTo(element);
					this.last = element;
				} else {
					this.top = element;
					this.last = element;
				}
			}

			/**
				Removes the top/oldest element of `this`.
				Be sure that `this` queue is not empty.
			**/
			public inline function dequeue(): $linkableType {
				final top = this.top.unwrap();
				this.top = top.next;
				top.unlinkNext();
				return top;
			}

			/**
				Runs `callback` for each node in `this` queue.
			**/
			public inline function forEach(callback: (node: $linkableType) -> Void): Void {
				final maybeTop = this.top;
				if (maybeTop.isSome()) maybeTop.unwrap().traverse(callback);
			}

			/**
				Clears `this` queue and runs `reset()` for each node.
			**/
			public inline function clear(): Void {
				final maybeTop = this.top;
				if (maybeTop.isSome()) {
					maybeTop.unwrap().traverseReset();
					this.top = sneaker.types.Maybe.none();
					this.last = sneaker.types.Maybe.none();
				}
			}

			/**
				Clears `this` queue without affecting the nodes.
			**/
			public inline function clearWeak(): Void {
				this.top = sneaker.types.Maybe.none();
				this.last = sneaker.types.Maybe.none();
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
						macro this.top = sneaker.types.Maybe.none(),
						macro this.last = sneaker.types.Maybe.none()
					]
				}
			default:
		}
		buildFields.push(constructor);

		return buildFields.concat(classDef.fields);
	}
}
#end
