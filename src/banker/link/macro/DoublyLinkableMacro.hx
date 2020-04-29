package banker.link.macro;

#if macro
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

		final classDef = macro class DoublyLinkableBase {
			/**
				Interconnects `former` and `latter`.
			**/
			public static inline function link(
				former: $localClassComplexType,
				latter: $localClassComplexType
			): Void {
				former.next = latter;
				latter.previous = former;
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
				former.next = sneaker.types.Maybe.from(null);
				latter.previous = sneaker.types.Maybe.from(null);
			}

			/**
				The next node linked from `this`.
			**/
			public var next: sneaker.types.Maybe<$localClassComplexType>;

			/**
				The previous node linked from `this`.
			**/
			public var previous: sneaker.types.Maybe<$localClassComplexType>;

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
				final next = this.next;
				if (next.isSome()) unlink(this, next.unwrap());
			}

			/**
				Disconnects `this` and its previous node (if exists) from each other.
			**/
			public inline function unlinkPrevious(): Void {
				final previous = this.previous;
				if (previous.isSome()) unlink(previous.unwrap(), this);
			}

			/**
				Runs `callback` for each node in the list starting from `this` until the last node.
			**/
			public inline function traverse(
				callback: (node: $localClassComplexType) -> Void
			): Void {
				var current = this.next;
				callback(this);
				while (current.isSome()) {
					final node = current.unwrap();
					current = node.next;
					callback(node);
				}
			}

			/**
				Runs `callback` for each node in the list starting from `this` until the first node.
			**/
			public inline function traverseBackwards(
				callback: (node: $localClassComplexType) -> Void
			): Void {
				var current = this.previous;
				callback(this);
				while (current.isSome()) {
					final node = current.unwrap();
					current = node.previous;
					callback(node);
				}
			}

			/**
				Clears the links from `this`.
				Note that this does not affect the next/previous nodes of `this`.
			**/
			public inline function reset(): Void {
				this.previous = sneaker.types.Maybe.from(null);
				this.next = sneaker.types.Maybe.from(null);
			}

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

			/**
				Runs `reset()` for each node in the list starting from `this` until the first node.
			**/
			public inline function traverseResetBackwards(): Void {
				var current = this.next;
				this.reset();
				while (current.isSome()) {
					final node = current.unwrap();
					current = node.previous;
					node.reset();
				}
			}

			/**
				Removes `this` from the list to which it belongs without dividing the whole list, i.e.
				interconnects the previous/next nodes of `this` and then calls `this.reset()`.
			**/
			public inline function removeSplice(): Void {
				final previous = this.previous;
				final next = this.next;

				if (previous.isSome()) previous.unwrap().next = next;
				if (next.isSome()) next.unwrap().previous = previous;

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
						macro this.next = sneaker.types.Maybe.none(),
						macro this.previous = sneaker.types.Maybe.none()
					]
				}
			default:
		}
		buildFields.push(constructor);

		return buildFields.concat(classDef.fields);
	}
}
#end
