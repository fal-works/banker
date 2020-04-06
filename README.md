# banker

Data structures.

**Requires Haxe 4** (developed with v4.0.5).


## Features

### Vector

Fixed-length array. Unlike the standard `haxe.ds.Vector`,

- Read-only type and Writable type are strictly separated.
- Uses `hl.NativeArray` on HashLink target.

### Data collection classes

Internally based on the vector type above.

- Stack / List
- Queue / Deque
- Set / Map
- ...

No allocation/GC by adding/removing/iterating elements.

### "Watermark" feature

For profiling usage ratio of data collection objects.

### AoSoA generator

Generates [AoSoA (Array of Structures of Arrays)](https://en.wikipedia.org/wiki/AoS_and_SoA) from any user-defined class.

### "FiniteKeys" generator

Generates a map-like class from any user-defined enum abstract type.

### Other

Some other small features like `Array` extensions or `ObjectPool` classes.

### Overall

Unlike the general data containers,

- No automatic expanding (simply crashes if it's full)
- No iterators (because they have overheads and invoke GC)

Internally uses assertion feature of [sneaker](https://github.com/fal-works/sneaker) library, which means:  

- Boundary checks in debug build, and  
- Unsafe, but efficient access in release build


## When to use

Primarily intended for use in game programming.

Suited for following situations:

- Lots of iteration
- Frequent access/changes
- Need to eliminate (or reduce, at least) Garbage Collection pauses
- Reducing overhead is more important than time complexity

## Caveats

- All of this is nothing but reinventing the wheel!
- Don't know much about other libraries/frameworks
- Developed within a few weeks and not yet very well tested
- Super-unstable!!!

---

## package: array

Utility functions/extensions for the basic `Array` type.

Might be more efficient than the standard `Lambda`.

## package: vector

Fixed-length array.

![Class diagram. Visit GitHub repo for details.](docs/vector.svg)

## package: container

Collection classes with 1 type parameter.

![Class diagram. Visit GitHub repo for details.](docs/container.svg)

## package: linker

Collection classes with 2 type parameters.

![Class diagram. Visit GitHub repo for details.](docs/linker.svg)

## package: pool

Provides object pool classes:

- `ObjectPool<T>`
- `SafeObjectPool<T>`

Say you have a class named `Actor`, an example would be:

```haxe
import banker.pool.ObjectPool;

class Main {
	static function main() {
		final factory = () -> new Actor();
		final pool = new ObjectPool<Actor>(10, factory);

		final actorA = pool.get();
		final actorB = pool.get();
		// pool.size == 8

		pool.put(actorA);
		pool.put(actorB);
		// pool.size == 10
	}
}
```

`ObjectPool` can also be extended for your own purpose, like `SafeObjectPool` does.

`SafeObjectPool` does boundary checks and does not crash even if it is empty/full  
(note that it requires additional memory allocation when trying to get from an empty pool).


## package: watermark

If the compiler flag `banker_watermark_enable` is set, "watermark" feature is activated.

This is a simple profiling feature for all data collection objects (in `container`, `linker` and `pool` packages)
that have limited capacity.

It automatically records the maximum usage (size to capacity ratio) per instance group,  
which enables you to check and adjust the capacity of each data collection object.

Instances are grouped by the name of `Tag` that is attached to each instance.  
About the `Tag`s, see also the [sneaker](https://github.com/fal-works/sneaker) library which underlies this feature.

### How to use

Just set the compiler flag `banker_watermark_enable`, and the profiling runs automatically.

To see the result, call the below whenever you like:

```haxe
banker.watermark.Watermark.printData();
```

## package: aosoa

First create your entity class, and implement `banker.aosoa.Structure`,  
which enables you to use an [AoSoA (Array of Structures of Arrays)](https://en.wikipedia.org/wiki/AoS_and_SoA)  
generated from your original class.

See also:  
[Data-oriented design](https://en.wikipedia.org/wiki/Data-oriented_design)

Caveats:  
The main purpose is improving the performance, however I still don't know much about low-level programming and I might be doing everything wrong!

### Overview

Here `move()`/`use()` are user-defined functions;
and `Position`/`Velocity` are user-defined values.

You can define any variables and functions for your purpose.

![Class diagram. Visit the GitHub repo for details.](docs/aosoa.svg)

### Example

Define any class (`Actor` here, which has x/y position data) and implement `banker.aosoa.Structure`.

```haxe
import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	/**
		This will append a method `use(initialX, initialY)` to the AoSoA class.
	**/
	@:banker.useEntity
	static function use(
		x: Vec<Float>, y: Vec<Float>, i: Int, initialX: Float, initialY: Float
	): Void {
		x[i] = initialX;
		y[i] = initialY;
	}

	/**
		This will append a method `print()` (without arguments) to the AoSoA.
	**/
	static function print(x: Float, y: Float): Void {
		trace('{ x: $x, y: $y }');
	}

	/**
		This will append `moveHorizontal(dx)`.
	**/
	static function moveHorizontal(
		x: Vec<Float>,
		dx: Float,
		i: Int
	): Void {
		x[i] += dx;
	}

	/** This will be converted to a vector. **/
	var x: Float = 0;

	/** Ditto. **/
	var y: Float = 0;
}
```

Then define Chunk/AoSoA classes as below.  
Their fields are generated by the build macro.

```haxe
import banker.vector.WritableVector as Vec; // same import as the Structure

@:build(banker.aosoa.Chunk.fromStructure(Actor))
class ActorChunk {}
```

```haxe
@:build(banker.aosoa.Aosoa.fromChunk(ActorChunk))
class ActorAosoa {}
```

Now you can create an AoSoA by `new ActorAosoa(chunkCapacity, chunkCount);`.

```haxe
class Main {
	static function main() {
		// (2 entities per Chunk) * (3 Chunks) = (max 6 entities)
		final actors = new ActorAosoa(2, 3);

		trace("Use 4 entities and print them.");
		for (i in 0...4) actors.use(i, i); // set both x and y to i
		actors.synchronize(); // Necessary for reflecting any change
		actors.print();

		trace("Move all and print again.");
		actors.moveHorizontal(10); // x += 10 for each
		actors.synchronize();
		actors.print();
	}
}
```

```
Main.hx:6: Use 4 entities and print them.
Actor.hx:26: { x: 0, y: 0 }
Actor.hx:26: { x: 1, y: 1 }
Actor.hx:26: { x: 2, y: 2 }
Actor.hx:26: { x: 3, y: 3 }
Main.hx:11: Move all and print again.
Actor.hx:26: { x: 10, y: 0 }
Actor.hx:26: { x: 11, y: 1 }
Actor.hx:26: { x: 12, y: 2 }
Actor.hx:26: { x: 13, y: 3 }
```

### Details

#### About "Chunk" and "AoSoA"

- An AoSoA consists of multiple Chunks (or SoA: Structure of Arrays).
- Each chunk has a fixed capacity and consists of vector data that are converted from the original `Structure` class with the same variable names.

#### User-defined functions

-	Any static `Void` function with metadata `@:banker.useEntity` is converted to a method which finds a new available entity and sets initial values.
- Any other static `Void` function is converted to an iterator method, which iterates all entities that are currently in use.
- You should not write `return` explicitly in these functions as the expressions are simply copied into `while` loops.

#### User-defined function arguments

- Arguments that match any of the variable names are internally provided in the AoSoA/Chunk so you don't need to pass them manually.
- Define an argument with the original type (e.g. `x: Float`) to get READ access.
- Define an argument with the vector type (e.g. `x: banker.vector.WritableVector<Float>`) for WRITE access.
- If you need WRITE access, you also have to include a special argument `i: Int`.  
Then use it as an index for writing to vectors.
- For disusing (releasing) an entity, define a special argument `disuse: Bool` in any iterator function.  
Then write `disuse = true` under any condition. This will release the entity the next time you call `synchronize()` (below).
- You can also include any chunk-level variable (see below) in arguments. This automatically declares local variables before the loop and saves the change (if not `final`) after the loop, so that you don't need to manually access `this.myChunkLevelVariable`.

#### Synchronization

- Each AoSoA instance has a method `synchronize()`, which reflects use/disuse/other changes of entities.  
The changes are buffered and are not reflected unless you call this.
- If you have any function (either entity-level iterator or chunk-level method) with metadata `@:banker.onSynchronize` or `@:banker.onCompleteSynchronize`, that function is automatically called for each chunk before/after the synchronization when `synchronize()` is called.

#### Initializing variables

- Type hint is mandatory when declaring variables in your `Structure` class.
- You can set an initializing value at the declaration, e.g. `var x: Float = 0`, which will be used for every entity.
- Add metadata `@:banker.factory(anyFactoryFunction)` to the variable to use the factory function instead of filling all entities with the same value.
- If you provide neither an inital value nor a factory, you have to pass the initial value to `new()` when instanciating the AoSoA class.
- Add metadata `@:banker.externalFactory` to the variable for enabling to pass any factory function instead of constant value when instanciating the AoSoA class.

#### Chunk-level fields

- If a field has `@:banker.chunkLevel` metadata, it will be copied to the Chunk class without converting to vectors or iterators (written above).
- Static variables are automatically considered as chunk-level.
- By adding metadata `@:banker.chunkLevelFactory` you can specify a factory function `(chunkCapacity: Int) -> ?` for a chunk-level variable. In that case `@:banker.chunkLevel` metadata can be omitted.

#### Debug

- Set the compiler flag `sneaker_macro_log_level` to 500 or more to show debug logs during the class generation.
- By adding metadata `@:banker.verified` to your `Structure` class, you can suppress debug logs for that class individually, without changing the whole log level.

#### List of metadata

|Metadata|Category|Description|
|---|---|---|
|@:banker.useEntity|method|Mark function as a "use" method|
|@:banker.factory|variable|Specifies a factory function for initializing each element of vector|
|@:banker.externalFactory|variable|Enables to pass any factory function to `new()` for inializing each element of vector (or the variable itself if chunk-level)|
|@:banker.hidden|field|Prevents to be copied to Chunk/AoSoA|
|@:banker.swap|variable|Swap elements (instead of overwriting) when disusing entity|
|@:banker.chunkLevel|field|Mark as a chunk-level field|
|@:banker.chunkLevelFinal|variable|Mark as a chunk-level `final` variable|
|@:banker.chunkLevelFactory|variable|Specifies function `(chunkCapacity: Int) -> ?` for initializing a chunk-level variable|
|@:banker.onSynchronize|method|Mark method so that it is automatically called before every synchronization|
|@:banker.onCompleteSynchronize|method|Mark method so that it is automatically called after every synchronization|
|@:banker.verified|class|Mark as verified|


## package: finite

Provides a build macro for creating a map-like class from an enum abstract type.

Say you have an enum abstract like this:

```haxe
enum abstract MyEnumAbstract(Int) {
	final A;
	final B;
	final C;
}
```

You can create a class with build macro `banker.finite.FiniteKeys.from()`,
where all enum values are converted to a variable with any specified type.

### Creating a set

Without providing any initial value, each variable has `Bool` type, initialized with `false`.

```haxe
@:build(banker.finite.FiniteKeys.from(MyEnumAbstract))
class MySet {}
```

```haxe
final mySet = new MySet();
trace(mySet.A); // false
mySet.A = true;
trace(mySet.A); // true
```

### Creating a map

You can specify an initial value with any type by adding a variable that is either:

- named `initialValue`, or
- added `@:banker.initialValue` metadata.

```haxe
@:build(banker.finite.FiniteKeys.from(MyEnumAbstract))
class MyMap {
	static final initialValue: Int = 0;
}
```

You can also specify a function, which will be treated as a factory function for initializing each variable.

```haxe
@:build(banker.finite.FiniteKeys.from(MyEnumAbstract))
class MyMap2 {
	static function initialValue(key: MyEnumAbstract): Int {
		return switch key {
			case A: 1;
			case B: 2;
			case C: 3;
		};
	}
}
```

The class will also have some methods such as `get(key)`, `set(key, value)` and `forEach(callback)`.

### Make read-only

By adding `@:banker.final` metadata to the class,

- All generated variables will be declared as `final`, and
- The class will not have setter methods.

### Debug log

Similar to the `aosoa` package,

- Set the compiler flag `sneaker_macro_log_level` to 500 or more to show debug logs during the generation.
- You can suppress debug logs without changing the whole log level by adding `@:banker.verified` metadata to your class.


## Doesn't work?

Regarding packages `container`, `linker`, `pool` and `aosoa`:

If you are using [completion server](https://haxe.org/manual/cr-completion-server.html), sometimes it might go wrong and raise odd errors due to reusing of macro context.  
In that case you may have to reboot it manually (if VSCode, `>Haxe: Restart Language Server` or `>Developer: Reload Window`).


## Compilation flags

|library|flag|description|
|---|---|---|
|banker|banker_watermark_enable|Enables watermark mode (see above).|
|banker|banker_generic_disable|Disables `@:generic` meta.|
|sneaker|sneaker_macro_log_level|Threshold for filtering macro logs. 500 or more to show all, less than 300 to hide all.|
|sneaker|sneaker_macro_message_level|Similar to above. See [sneaker](https://github.com/fal-works/sneaker) for more details.|


## Dependencies

- [sneaker](https://github.com/fal-works/sneaker) (v0.8.1) for assertion, logging and macro utilities
- [ripper](https://github.com/fal-works/ripper) (v0.3.0) for partial implementation
