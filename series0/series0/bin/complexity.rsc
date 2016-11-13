module complexity

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;

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
	}

	return count;	
}