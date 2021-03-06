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

map[str, real] aggregateUnitRiskLineRatios(model)
{
	map[str, real] m = ("mod": 0.0, "hi": 0.0, "ex": 0.0);
	for (method <- methods(model))
	{
		c = countLines(method);
		if (c > 125)
		{
			if (c < 150) m["mod"] += countLines(method);
			else if (c < 200) m["hi"] += countLines(method);
			else m["ex"] += countLines(method);
		}
	}
	vol = volume(model);
	m["mod"] = toReal(m["mod"])/vol*100;
	m["hi"] = toReal(m["hi"])/vol*100;
	m["ex"] = toReal(m["ex"])/vol*100;
	return m;
}

str gradeUnitSize(model)
{
	m = aggregateUnitRiskLineRatios(model);
	if (m["ex"] > 5.0 || m["hi"] > 15.0 || m["mod"] > 50.0) return "--";
	if (m["ex"] > 0.0 || m["hi"] > 10.0 || m["mod"] > 40.0) return "-";
	if (m["ex"] > 0.0 || m["hi"] > 5.0 || m["mod"] > 30.0) return "o";
	if (m["ex"] > 0.0 || m["hi"] > 0.0 || m["mod"] > 25.0) return "+";
	return "++";
}
