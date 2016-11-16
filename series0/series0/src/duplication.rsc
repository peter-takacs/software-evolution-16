module duplication

import lang::java::jdt::m3::Core;
import IO;
import String;
import Set;
import List;
import Map;
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

list[loc] grow(group, chunks)
{
	return [growLine(g, nextLine(g, chunks)) | g <- group];
}

list[list[loc]] createDuplicateGroups(m)
{
	allChunks = ([] | it + toList(c) | c <- toList(range(m)));
	return groupDomainByRange(allChunks);
}

list[tuple[loc, tuple[loc, str]]] chunkifyFiles(model)
{
	return ([] | it + chunkify(f) | f <- files(model));
}

list[list[str]] search(chunks, grain) {
	startOffset = 0;
	result = [];
	needle = chunks[0..grain];
	haystack = chunks[grain..];
	while (size(haystack) > size(needle))
	{
		startOffset = 0;
		while (startOffset < size(haystack) - grain)
		{
			if (needle == haystack[startOffset..startOffset+grain])
			{
				result = result + [needle];
				return;
			}
			startOffset = startOffset + 1;
		}
		needle = drop(1,needle) + haystack[0];
		haystack = drop(1, haystack);
		println(size(haystack));
	}
	return result;
}

list[list[str]] comb(chunks)
{
	grain = 100;
	result = [];
	while (result == [])
	{
		result = result + search(chunks, grain);
		grain = grain / 2;
		println(grain);
	}
	return result;
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
