package banker.binary.value_types;

/**
	32-bit float if available on platform. Otherwise 64-bit `Float`.
**/
#if hl
abstract Float32(Single) from Float from Single from hl.F32 to Float to Single
	to hl.F32 {}
#elseif cpp
abstract Float32(Single) from Float from Single from cpp.Float32 to Float to Single
	to cpp.Float32 {}
#else
typedef Float32 = #if (java || cs) Single #else Float #end;
#end
