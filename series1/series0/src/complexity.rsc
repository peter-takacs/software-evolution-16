module complexity

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;
import util::Math;
import volume;

int complexity(method, myModel) {
	ast = getMethodASTEclipse(method, model=myModel);
	count = 0;
	visit (ast) {
		case \if(_, __): count = count + 1;
		case \if(_, __, ___): count = count + 1;
		case \do(_, __): count = count + 1;
		case \for(_, __, ___, ____): count = count + 1;
		case \for(_, __, ___): count = count + 1;
		case \switch(_, __): count = count + 1;
		case \while(_, __): count = count + 1;
		case \case(_,__): count = count + 1;
		case \catch(_,__): count = count + 1;
		case \do(_, __): count = count + 1;
		case foreach(_, __,___): count = count + 1;
		case \catch(_, __): count = count + 1;
		case \conditional(_, __, ___): count = count + 1;
		case infix(_,"&&",_) : count = count + 1;
        case infix(_,"||",_) : count = count + 1;
	}

	return count;	
}

map[str, real] aggregateRiskLineRatios(model)
{
	map[str, real] m = ("mod": 0.0, "hi": 0.0, "ex": 0.0);
	for (method <- methods(model))
	{
		c = complexity(method, model);
		if (c > 11)
		{
			if (c < 20) m["mod"] += countLines(method);
			else if (c < 50) m["hi"] += countLines(method);
			else m["ex"] += countLines(method);
		}
	}
	vol = volume(model);
	m["mod"] = toReal(m["mod"])/vol*100;
	m["hi"] = toReal(m["hi"])/vol*100;
	m["ex"] = toReal(m["ex"])/vol*100;
	return m;
}

map[str, tuple[int,int]] getAverageUnitSizePerRiskCategory(model)
{
	map[str, tuple[int,int]] m = ("mod": <0,0>, "hi": <0,0>, "ex": <0,0>);
	for (method <- methods(model))
	{
		c = complexity(method, model);
		if (c > 11)
		{
			if (c < 20) m["mod"] = <m["mod"][0]+1, m["mod"][1] + countLines(method)*countLines(method)>;
			else if (c < 50) m["hi"] = <m["hi"][0]+1, m["hi"][1] + countLines(method)*countLines(method)>;
			else m["ex"] = <m["ex"][0]+1, m["ex"][1] + countLines(method)*countLines(method)>;
		}
	}
	map[str, real] output = ("mod": 0.0, "hi": 0.0, "ex": 0.0);
	output["mod"] = sqrt(toReal(m["mod"][1])/m["mod"][0]);
	output["hi"] = sqrt(toReal(m["hi"][1])/m["hi"][0]);
	output["ex"] = sqrt(toReal(m["ex"][1])/m["ex"][0]);
	return m;
}

str gradeComplexity(model)
{
	m = aggregateRiskLineRatios(model);
	if (m["ex"] > 5.0 || m["hi"] > 15.0 || m["mod"] > 50.0) return "--";
	if (m["ex"] > 0.0 || m["hi"] > 10.0 || m["mod"] > 40.0) return "-";
	if (m["ex"] > 0.0 || m["hi"] > 5.0 || m["mod"] > 30.0) return "o";
	if (m["ex"] > 0.0 || m["hi"] > 0.0 || m["mod"] > 25.0) return "+";
	return "++";
}

