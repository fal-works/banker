package banker.common.internal;

#if macro
import haxe.macro.Type.ClassType;

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
		Sets `verified` and `notVerified` according to the `@:banker.verified` metadata.
	**/
	public static function setVerificationState(classType: ClassType): Void {
		final meta = classType.meta;
		verified = (meta.has(verifiedMetadataName) || meta.has(verifiedMetadataName_));
		notVerified = !verified;
	}

	static final verifiedMetadataName = ":banker.verified";
	static final verifiedMetadataName_ = ":banker_verified";
}
#end
