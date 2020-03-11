# banker

Data containers.

**Requires Haxe 4** (tested with v4.0.5).


## Features

- Fixed-length array (or `Vector`)
- Array-based List, Stack, Queue, Deque, Set, Map, ...

- Internally uses assertion feature of [sneaker](https://github.com/fal-works/sneaker) library, which means:  
(1) Boundary checks in debug build, and  
(2) Unsafe, but efficient access in release build

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

## Structure

### package: vector

Fixed-length array.

![class diagram of vector package](docs/vector.svg)

### package: container

Collection classes with 1 type parameter.

![class diagram of container package](docs/container.svg)

### package: linker

Collection classes with 2 type parameters.

![class diagram of linker package](docs/linker.svg)

### package: pool

Provides object pool classes:

- `ObjectPool<T>`
- `SafeObjectPool<T>`

### package: watermark

If the compiler flag `banker_watermark_enable` is set, "watermark" feature is activated.

This is a simple profiling feature for all data collection objects (in `container` and `linker` packages) with limited capacity.

It automatically records the maximum usage (size to capacity ratio) per instance group,  
which enables you to check and adjust the capacity of each data collection object.

Instances are grouped by the name of `Tag` that is attached to each instance.  
About the `Tag`s, see also the [sneaker](https://github.com/fal-works/sneaker) library which underlies this feature.

#### How to use

Just set the compiler flag `banker_watermark_enable`, and the profiling runs automatically.

To see the result, import:

```haxe
import banker.watermark.Watermark;
```

and call `Watermark.printData()` whenever you like.



## Compilation flags

|flag|description|
|---|---|
|banker_watermark_enable|Enables watermark mode (see above).|
|banker_generic_disable|Disables `@:generic` meta.|
