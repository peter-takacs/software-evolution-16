module unitSize

import lang::java::jdt::m3::Core;
import IO;
import util::Math;
import Set;
import String;
import lang::java::m3::Core;
import volume;

real averageMethodSize(model) {
	allLines = toReal( (0 | it + lines(method) | method <- methods(model)));
	countOfMethods = toReal(size(methods(model)));
	return allLines / countOfMethods;
}
