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


## Compilation flags

|flag|description|
|---|---|
|banker_generic_disable|Disables `@:generic` meta.|
