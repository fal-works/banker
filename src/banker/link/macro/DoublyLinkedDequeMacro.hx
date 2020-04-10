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

class DoublyLinkedDequeMacro {
	/**
		The entry point of build macro for `DoublyLinkable` interface.
	**/
	public static function create(linkableTypeExpression: Expr): Null<Fields> {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();
		final localClassPathStringFull = '${localClass.module}.${localClass.name}';
		final localClassComplexType = Context.getType(localClassPathStringFull)
			.toComplexType();

		final resolved = ContextTools.resolveClassType(linkableTypeExpression, "banker.link.DoublyLinkable");
		if (resolved.isFailedWarn()) return null;
		final linkableType = resolved.unwrap().type.toComplexType();

		final classDef = macro class DoublyLinkedDeque {
			/**
				The top node in `this` deque.
			**/
			public var top: sneaker.types.Maybe<$linkableType>;

			/**
				The last node in `this` deque.
			**/
			public var last: sneaker.types.Maybe<$linkableType>;

			/**
				Adds `element` as the last element of `this`.
			**/
			public inline function pushBack(element: $linkableType): Void {
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
				Removes the top element of `this`.
				Be sure that `this` deque is not empty.
			**/
			public inline function popFront(): $linkableType {
				final top = this.top.unwrap();
				this.top = top.next;
				top.unlinkNext();
				return top;
			}

			/**
				Adds `element` as the top element of `this`.
			**/
			public inline function pushFront(element: $linkableType): Void {
				final maybeTop = this.top;
				if (maybeTop.isSome()) {
					maybeTop.unwrap().linkFrom(element);
					this.top = element;
				} else {
					this.top = element;
					this.last = element;
				}
			}

			/**
				Removes the last element of `this`.
				Be sure that `this` deque is not empty.
			**/
			public inline function popBack(): $linkableType {
				final last = this.last.unwrap();
				this.last = last.previous;
				last.unlinkPrevious();
				return last;
			}

			/**
				Runs `callback` for each node in `this` deque.
			**/
			public inline function forEach(callback: (node: $linkableType) -> Void): Void {
				final maybeTop = this.top;
				if (maybeTop.isSome()) maybeTop.unwrap().traverse(callback);
			}

			/**
				Clears `this` deque and runs `reset()` for each node.
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
				Clears `this` deque without affecting the nodes.
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
