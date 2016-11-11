module complexity

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;

int complexity(method, myModel) {
	ast = getMethodASTEclipse(method, model=myModel);
	return (0 | it + 1 | /\if(_, __) := ast) + 
			(0 | it + 1 | /\if(_, __, ___) := ast) +
			(0 | it + 1 | /\do(_, __) := ast) +
			(0 | it + 1 | /\for(_, __, ___, ___) := ast) +
			(0 | it + 1 | /\for(_, __, ___) := ast) +
			(0 | it + 1 | /\switch(_, __) := ast) + 
			(0 | it + 1 | /\while(_, __) := ast) ;
}