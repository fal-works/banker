package banker.aosoa.macro;

/**
	Information about a module.
**/
typedef ModuleInfo = {
	path: String,
	name: String,
	packagePath: String,
	packages: Array<String>
}

#if macro
/**
	Information about a type defined in any module.
**/
typedef DefinedType = {
	path: TypePath,
	pathString: String,
	complex: ComplexType
};
#end
