module duplication

import lang::java::jdt::m3::Core;
import IO;
import String;
import Set;
import List;
import ListRelation;
import lang::java::m3::Core;

bool extendsDuplicateGroup(a, b)
{
	if (size(a) != size(b)) return false;
	for (pair <- zip(a,b))
	{
		if (!extends(pair[0], pair[1])) return false;
	}
	return true;
}

bool extends(a, b) {
	return a.path == b.path && a.begin.line <= b.begin.line && a.end.line >= b.begin.line;
}

loc ext(a,b)
{
	return a(a.offset, a.length, <a.begin.line, a.begin.column>, <b.end.line, b.end.column>);
}

list[list[loc]] grow(groups)
{
	duplicateGroups = groups;
	i = 0;
	wasChange = true;
	println(size(groups));
	while (wasChange && i < 1)
	{
		result = [];
		merged = {};
		//println(i);
		//println(size(duplicateGroups));
		i = i+1;
		println(i);
		j=0;
		wasChange = false;
		for (list[loc] a <- duplicateGroups) {
			if (a in merged) continue;
			for (list[loc] b <- duplicateGroups)
			{
				if (a == b) continue;
				if (extendsDuplicateGroup(a,b))
				{
					println(a);
					println(b);
					a = [ext(e[0], e[1]) | e <- zip(a,b)];
					println(a);
					println("-------------------------");
					merged = merged + b;
					wasChange = true;
					break;
				}
			}
			if (wasChange || a[0].end.line-a[0].begin.line >= 6)
			{
				result = result + [a];
				println(a[0].end.line-a[0].begin.line);
				return;
			}
			println(j);
			j = j+1;
		}
		
		duplicateGroups = result;
	}
	return [];
}

list[list[tuple[loc, int]]] findDuplicatesInProject(model) {
	chunks = ([] | it + chunkify(c) | c <- classes(model));
	list[tuple[loc,str]] duplicateGroups = 
		[l| l <- findDuplicates(chunks), size(l) > 1];
	result = [];
	i = 0;
	wasChange = true;
	println(size(chunks));
	while (wasChange && i < 100)
	{
		println(i);
		i = i+1;
		wasChange = false;
		for (list[tuple[loc,str]] a <- duplicateGroups) {
			for (list[tuple[loc,str]] b <- duplicateGroups)
			{
				if (extendsDuplicateGroup(a,b))
				{
					a = [ext(e[0], e[1]) | e <- zip(a,b)];
					wasChange = true;
				}
			}
			result = result + [a];
		}
		duplicateGroups = result;
	}
	return duplicateGroups;
}

list[tuple[loc,str]] chunkify(class) {
	classText = squeeze(readFile(class), "\t ");
	lines = [];
	chunks = [];
	offset = 0;
	offsetChar = 0;
	for (/[\s]*<line:.*>\n/ := classText) {
		length = size(line);
		lines = lines + <class(offsetChar,length,<offset,0>,<offset,0>), line>;
		offsetChar = offsetChar + length;
		offset = offset + 1;
	}
	return lines;
}

list[list[loc]] findDuplicates(chunks) {
	return groupDomainByRange(chunks);
}
