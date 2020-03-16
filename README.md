# banker

Data containers.

**Requires Haxe 4** (tested with v4.0.5).


## Features

This library provides:

- Fixed-length array (or "vector"). Unlike the standard one,  
(1) Strict distinction between Read-only and Writable.  
(2) Uses `hl.NativeArray` on HashLink target.
- Array-based List, Stack, Queue, Deque, Set, Map, ...  
Internally based on the vector type above.  
Also going to add other implementations.
- (Experimental)  
Generate [AoSoA (Array of Structure of Arrays)](https://en.wikipedia.org/wiki/AoS_and_SoA) from any of user-defined classes.

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

## Downsides

- All of this is nothing but reinventing the wheel!
- Don't know much about other libraries/frameworks
- Developed within a week and not yet very well tested


## package: vector

Fixed-length array.

![class diagram of vector package](docs/vector.svg)

## package: container

Collection classes with 1 type parameter.

![class diagram of container package](docs/container.svg)

## package: linker

Collection classes with 2 type parameters.

![class diagram of linker package](docs/linker.svg)

## package: pool

Provides object pool classes:

- `ObjectPool<T>`
- `SafeObjectPool<T>`

## package: watermark

If the compiler flag `banker_watermark_enable` is set, "watermark" feature is activated.

This is a simple profiling feature for all data collection objects (in `container` and `linker` packages) with limited capacity.

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
which enables you to create an [AoSoA (Array of Structure of Arrays)](https://en.wikipedia.org/wiki/AoS_and_SoA).

### Example

Define a class (`Actor` here, which has x/y position data).

```haxe
import banker.vector.WritableVector as Vec;

class Actor implements banker.aosoa.Structure {
	/**
		This will append a method `use(initialX, initialY)`
		to the AoSoA class.
		`x`, `y` and `i` are provided interanlly/automatically.
	**/
	@:banker.useEntity
	static function use(
		x: Vec<Float>,
		y: Vec<Float>,
		initialX: Float,
		initialY: Float,
		i: Int
	): Void {
		x[i] = initialX;
		y[i] = initialY;
	}

	/**
		This will append a method `print()` (without arguments)
		to the AoSoA class.
	**/
	static function print(x: Float, y: Float): Void {
		trace('{ x: $x, y: $y }');
	}

	/**
		This will append a `moveHorizontal(dx)` to the AoSoA class.
		Runs `x += dx` for each entity.
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

Then you can create an AoSoA by `Actor.createAosoa(chunkSize, chunkCount);`.

Now use them as the below:

```haxe
class Main {
	static function main() {
		// (2 entities per Chunk) * (3 Chunks) = (max 6 entities)
		final actors = Actor.createAosoa(2, 3);

		trace("Use 4 entities and print them.");
		for (i in 0...4) actors.use(i, i); // set both x and y to i
		actors.synchronize(); // Necessary for reflecting any change
		actors.print();

		trace("Move all and print again.");
		actors.moveHorizontal(10); // x += 10 for each
		actors.synchronize(); // Sync again
		actors.print();
	}
}
```

### Details

An AoSoA consists of multiple Chunks (or SoA: Structure of Arrays).

Each chunk has a fixed capacity and contains vector type variables  
that are converted from the original `Structure` class.

Regarding the user-defined functions:

-	Any static function with `@:banker.useEntity` metadata is converted to a method  
which finds a new available entity and sets initial values to it.
- Any other static function is converted to an iterator method,  
which iterates all entities that are currently in use.

Regarding the function arguments:

- Arguments that match any of the original variable names are internally  
provided in the AoSoA/Chunk so you don't need to pass them manually.
- Define an argument with the original type (e.g. `x: Float`) to get READ access, or  
with the vector type (`x: banker.vector.WritableVector<Float>`) for WRITE access.
- If you need WRITE access, you also have to include a special argument `i: Int`  
and use it as an index for writing to vectors.
- For disusing (releasing) an entity, define a special argument `disuse: Bool` in  
any iterator function, and write `disuse = true` under any condition you'd like.  
This will release the entity the next time you call `synchronize()` (below).

Other:

- Each AoSoA instance has a method `synchronize()`, which reflects  
use/disuse/other changes of entities.  
The changes are buffered and are not reflected unless you call this.


## Compilation flags

|flag|description|
|---|---|
|banker_watermark_enable|Enables watermark mode (see above).|
|banker_generic_disable|Disables `@:generic` meta.|


## Dependencies

- [sneaker](https://github.com/fal-works/sneaker) for assertion and logging
- [ripper](https://github.com/fal-works/ripper) for partial implementation
