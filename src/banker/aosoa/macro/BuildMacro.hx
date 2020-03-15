package banker.aosoa.macro;

#if macro
using Lambda;

import haxe.macro.Context;

class BuildMacro {
	/**
		The entry point of build macro for `Structure` interface.
		Rebuilds the class as an AoSoA (Array of Structure of Arrays).
	**/
	public static function build(): Fields {
		debug("Start to build.");

		final localClass = Context.getLocalClass();
		if (localClass == null) {
			warn("Could not determine in which class the macro was called.");
			return null;
		}

		final localClassName = localClass.get().name;
		final position = Context.currentPos();
		final buildFields = Context.getBuildFields();

		final chunk = Chunk.create(
			buildFields,
			localClassName,
			position
		);
		final chunkType = MacroTools.defineSubTypes([chunk.typeDefinition])[0];
		debug('Created Chunk class: ${chunkType.pathString}');

		final aosoaClassName = localClassName + "Aosoa";
		final aosoaClass = Aosoa.create(
			aosoaClassName,
			chunk,
			chunkType,
			position
		);
		final aosoaType = MacroTools.defineSubTypes([aosoaClass])[0];
		debug('Created Aosoa class: ${aosoaType.pathString}');

		final aosoaTypePath = aosoaType.path;
		final createAosoaMethod: Field = {
			name: "createAosoa",
			kind: FFun({
				args: [
					{ name: "chunkSize", type: (macro:Int)},
					{ name: "chunkCount", type: (macro:Int)}
				],
				ret: aosoaType.complex,
				expr: macro return new $aosoaTypePath(chunkSize, chunkCount)
			}),
			access: [APublic, AStatic],
			pos: Context.currentPos()
		};
		buildFields.push(createAosoaMethod);

		sneaker.print.Printer.println("structure:");
		for (field in buildFields) sneaker.print.Printer.println(field.name);
		sneaker.print.Printer.println("chunk:");
		for (field in chunk.typeDefinition.fields) sneaker.print.Printer.println(field.name);
		sneaker.print.Printer.println("aosoa:");
		for (field in aosoaClass.fields) sneaker.print.Printer.println(field.name);

		debug("End building.");
		return buildFields;
	}
}
#end
