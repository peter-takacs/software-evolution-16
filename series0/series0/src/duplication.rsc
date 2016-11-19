module duplication

import lang::java::jdt::m3::Core;
import IO;
import String;
import Set;
import List;
import Type;
import Map;
import ListRelation;
import lang::java::m3::Core;

loc nextLine(needle, haystack)
{
	for (hay <- haystack)
	{
		if (hay.uri == needle.uri && needle.end.line+1 == hay.begin.line) return hay;
	}
	return needle;
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
	nextLines = [<g,lines[nextLine(g, locs)][0]> | g <- group, nextLine(g, locs) != g];
	if (size(nextLines) != size(group)) return group; //We couldn't find the next line
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

bool containsLoc(a,b)
{
	return a.uri == b.uri && a.offset<= b.offset && a.offset+a.length > b.offset;
}

list[list[loc]] findDuplicateChunks(pGroups, pLocs, pLines)
{
	result = [];
	locs = pLocs;
	lines = pLines;
	for (group <- pGroups)
	{
		maximum = growUntilPossible(group, locs, lines);
		println("alma");
		for (e <- maximum)
		{
			locs = [l | l<-locs, !containsLoc(e, l)];
			lines = [l | l<-lines, !containsLoc(e, l[0])];
		} 
		result = result + [maximum];
		println(typeOf(result));
	}
	return result;
}

list[list[loc]] findDuplicateChunksInProject(location) {
	model = createM3FromEclipseProject(location);
	lines = range(chunkifyFiles(model));
	groups = groupDomainByRange(lines);
	locs = [x[0] | x<-lines];
	return findDuplicateChunks(groups, locs, lines);
}

value modelLinesGroupsLocs(location)
{
	model = createM3FromEclipseProject(location);
	lines = range(chunkifyFiles(model));
	groups = groupDomainByRange(lines);
	locs = [x[0] | x<-lines];
	return <model, lines, groups, locs>;	
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
