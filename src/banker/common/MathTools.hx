package banker.common;

class MathTools {
	public static inline function minInt(a: Int, b: Int): Int
		return if (a < b) a else b;

	public static inline function maxInt(a: Int, b: Int): Int
		return if (a < b) b else a;

	public static inline function absoluteInt(n: Int): Int
		return if (0 <= n) n else -n;
}
