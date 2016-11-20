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

loc nextLine(loc needle, list[loc] haystack, lrel[str,tuple[loc,int]] filesToChunks)
{
	for (hay <- filesToChunks[needle.uri])
	{
		if (hay[0].uri == needle.uri && needle.end.line+1 == hay[0].begin.line) return hay[0];
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

list[loc] grow(group, locs, lines, filesToChunks)
{
	nextLines = [];
	nextLocs = [];
	for (g <- group)
	{
		nloc = nextLine(g, locs, filesToChunks);
		nl = lines[nloc];
		if (size(nl) == 0 || nextLine(g, locs, filesToChunks) == g) return group;
		nextLines = nextLines + <g,nl[0]>;
		nextLocs = nextLocs + <g,nloc>;
	}
	if (size(nextLines) != size(group)) return group; //We couldn't find the next line
	list[list[loc]] grownGroups = groupSameLines(nextLines);
	list[loc] biggestGroup = getBiggestGroup(grownGroups);
	if (size(biggestGroup) < 2) return group;
	return [growLine(g, nextLine(g, locs, filesToChunks)) | g <- biggestGroup];
}

list[loc] growUntilPossible(group, locs, lines, filesToChunks)
{
	previous = null;
	current = group;	
	while (previous != current)
	{
		previous = current;
		current = grow(current, locs, lines, filesToChunks);
	}
	return current;
}

bool containsLoc(a,b)
{
	return a.uri == b.uri && a.offset<= b.offset && a.offset+a.length > b.offset;
}

list[list[loc]] findDuplicateChunks(pGroups, pLocs, pLines, pFtc)
{
	result = [];
	locs = pLocs;
	lines = pLines;
	i = 0;
	for (group <- pGroups)
	{
		i = i+1;
		println(i);
		maximum = growUntilPossible(group, locs, lines, pFtc);		
		result = result + [maximum];
	}
	return result;
}

list[list[loc]] findDuplicateChunksInProject(location) {
	model = createM3FromEclipseProject(location);
	filesToChunks = chunkifyFiles(model);
	lines = range(filesToChunks);
	groups = groupSameLines(lines);
	locs = [x[0] | x<-lines];
	return deleteOverlapping(findDuplicateChunks(groups, locs, lines, filesToChunks));
}

list[list[loc]] deleteOverlapping(list[list[loc]] groups)
{
	queue = groups;
	result = [];
	while (size(queue) > 0)
	{
		println(size(queue));
		current = queue[0];
		delete(queue, 0);
		queue = [x | x<-queue, !(x[0].uri == current[0].uri && 
			((current[0].begin.line <= x[0].begin.line && current[0].end.line >= x[0].end.line)
			||
			(x[0].begin.line <= current[0].begin.line && x[0].end.line >= current[0].end.line)))];
		result = result + [current];
	}
	return result;
}

list[list[loc]] groupSameLines(list[tuple[loc, int]] lines)
{
	list[tuple[loc, int]] st = sort(lines, bool(tuple[loc,int] a, tuple[loc,int] b) {return a[1]>b[1];});
	list[list[loc]] result = [];
	int currentTag = st[0][1];
	list[loc] currentGroup = [];
	for (c <- st)
	{
		if (c[1] == currentTag)
		{
			currentGroup = currentGroup + c[0];
		}
		else
		{
			if (size(currentGroup) > 1)
			{
				result = result + [currentGroup];
			}
			currentGroup = [c[0]];
			currentTag = c[1];
		}
	}
	if (size(currentGroup) > 1) result = result + [currentGroup];
	return result;
}

tuple[M3, list[tuple[loc,int]], list[list[loc]], list[loc]] modelLinesGroupsLocs(location)
{
	model = createM3FromEclipseProject(location);
	lines = range(chunkifyFiles(model));
	groups = groupSameLines(lines);
	locs = [x[0] | x<-lines];
	return <model, lines, groups, locs>;	
}

list[tuple[str, tuple[loc, int]]] chunkifyFiles(model)
{
	return ([] | it + chunkify(f) | f <- files(model));
}

list[tuple[str, tuple[loc,int]]] chunkify(fil) {
	classText = readFile(fil);
	lines = [];
	chunks = [];
	offset = 1;
	offsetChar = 0;
	for (/<whitespace:[\s\t]*><line:.*>\n/ := classText) {
		length = size(line) + size(whitespace) + 1; // \n
		lines = lines + <fil.uri, <fil(offsetChar,length,<offset,0>,<offset,0>), hashString(line)>>;
		offsetChar = offsetChar + length;
		offset = offset + 1;
	}
	return lines;
}

int hashString(string) {
	return (17 | (it * 23 + x) % 4294967296 | x <- chars(string));	
}