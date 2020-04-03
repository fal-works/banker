package banker.common.internal;

#if macro
import haxe.macro.Type.ClassType;
import haxe.macro.Expr.Position;

/**
	Global context of the macro process of banker.
**/
class MacroContext {
	/**
		Is set by `setVerificationState()`.
		DEBUG and INFO logs should be suppressed if this is `true`.
	**/
	public static var verified(default, null) = false;

	/**
		The opposite value of `verified`.
	**/
	public static var notVerified(default, null) = true;

	/**
		Current local class.
	**/
	public static var localClass(default, null): ClassType;

	/**
		Position of current local class.
	**/
	public static var localPosition(default, null): Position;

	/**
		Sets `verified` and `notVerified` according to the `@:banker.verified` metadata.
	**/
	public static function setVerificationState(?classType: ClassType): Void {
		if (classType != null) {
			localClass = classType;
			localPosition = classType.pos;
		}

		final meta = localClass.meta;
		verified = (meta.has(verifiedMetadataName) || meta.has(verifiedMetadataName_));
		notVerified = !verified;
	}

	static final verifiedMetadataName = ":banker.verified";
	static final verifiedMetadataName_ = ":banker_verified";
}
#end
