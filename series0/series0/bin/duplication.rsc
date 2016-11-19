module duplication

import lang::java::jdt::m3::Core;
import IO;
import String;
import Set;
import List;
import Map;
import ListRelation;
import lang::java::m3::Core;

loc nextLine(needle, haystack)
{
	for (hay <- haystack)
	{
		if (hay.uri == needle.uri && needle.end.line+1 == hay.begin.line) return hay;
	}
	return null;
}

loc growLine(current, next)
{
	return current(current.offset, 
					current.length + next.length,
					<current.begin.line, current.begin.column>,
					<next.end.line, next.end.column>); 
}

list[loc] getBiggestGroup(groups)
{
	maxSize = 0;
	maxGroup = [];
	for (g <- groups)
	{
		if (size(g) > maxSize)
		{
			maxSize = size(g);
			maxGroup = g;
		}
	}
	return maxGroup;
}

list[loc] grow(group, locs, lines)
{
	list[tuple[loc,str]] nextLines = [<g,lines[nextLine(g, locs)][0]> | g <- group];
	list[list[loc]] grownGroups = groupDomainByRange(nextLines);
	list[loc] biggestGroup = getBiggestGroup(grownGroups);
	if (size(biggestGroup) < 2) return group;
	return [growLine(g, nextLine(g, locs)) | g <- biggestGroup];
}

list[loc] growUntilPossible(group, locs, lines)
{
	previous = null;
	current = group;	
	while (previous != current)
	{
		previous = current;
		current = grow(current, locs, lines);
	}
	return current;
}



list[list[loc]] createDuplicateGroups(lines)
{
	return groupDomainByRange(lines);
}

list[tuple[loc, tuple[loc, str]]] chunkifyFiles(model)
{
	return ([] | it + chunkify(f) | f <- files(model));
}

list[tuple[loc, tuple[loc,str]]] chunkify(fil) {
	classText = squeeze(readFile(fil), "\t ");
	lines = [];
	chunks = [];
	offset = 0;
	offsetChar = 0;
	for (/[\s]*<line:.*>\n/ := classText) {
		length = size(line);
		lines = lines + <fil, <fil(offsetChar,length,<offset,0>,<offset,0>), line>>;
		offsetChar = offsetChar + length;
		offset = offset + 1;
	}
	return lines;
}
