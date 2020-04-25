package banker.link.macro;

#if macro
class SinglyLinkableMacro {
	/**
		The entry point of build macro for `SinglyLinkable` interface.
	**/
	static macro function build(): Null<Fields> {
		final localClassResult = ContextTools.getLocalClass();
		if (localClassResult.isFailedWarn()) return null;
		final localClass = localClassResult.unwrap();
		final localClassPathStringFull = '${localClass.module}.${localClass.name}';
		final localClassComplexType = Context.getType(localClassPathStringFull)
			.toComplexType();

		final classDef = macro class SinglyLinkableBase {
			/**
				Interconnects `former` and `latter`.
			**/
			public static inline function link(
				former: $localClassComplexType,
				latter: $localClassComplexType
			): Void {
				former.next = latter;
			}

			/**
				The next node linked from `this`.
			**/
			public var next: sinker.Maybe<$localClassComplexType>;

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
				Clears the link from `this` to the next node (if exists).
			**/
			public inline function unlinkNext(): Void
				this.next = sinker.Maybe.from(null);

			/**
				Runs `callback` for each node in the list starting from `this` until the last node.
			**/
			public inline function traverse(callback: (node: $localClassComplexType) -> Void): Void {
				var current = this.next;
				callback(this);
				while (current.isSome()) {
					final node = current.unwrap();
					current = node.next;
					callback(node);
				}
			}

			/**
				Clears the link from `this`. Same as `this.unlinkNext()`.
			**/
			public inline function reset(): Void
				this.unlinkNext();

			/**
				Runs `reset()` for each node in the list starting from `this` until the last node.
			**/
			public inline function traverseReset(): Void {
				var current = this.next;
				this.reset();
				while (current.isSome()) {
					final node = current.unwrap();
					current = node.next;
					node.reset();
				}
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
						macro this.next = sinker.Maybe.none()
					]
				}
			default:
		}
		buildFields.push(constructor);

		return buildFields.concat(classDef.fields);
	}
}
#end
