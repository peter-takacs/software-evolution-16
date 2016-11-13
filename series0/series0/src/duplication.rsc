module duplication

import lang::java::jdt::m3::Core;
import IO;
import String;
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
	return a[0] == b[0] && a[1] + a[2] > b[1];
}

tuple[loc, int, int] ext(a,b)
{
	return <a[0], a[1], a[2]-b[1]+b[2]>;
}

list[list[tuple[loc, int]]] findDuplicatesInProject(model) {
	chunks = ([] | it + chunkify(c) | c <- classes(model));
	list[list[tuple[loc, int, int]]] duplicateGroups = 
		[l| l <- findDuplicates(chunks), size(l) > 1];
	result = [];
	i = 0;
	wasChange = true;
	println(size(chunks));
	while (wasChange && i < size(chunks))
	{
		i = i+1;
		wasChange = false;
		for (list[tuple[loc, int, int]] a <- duplicateGroups) {
			for (list[tuple[loc, int, int]] b <- duplicateGroups)
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

list[tuple[tuple[loc, int, int],list[str]]] chunkify(class) {
	classText = squeeze(readFile(class), "\t ");
	lines = [];
	chunks = [];
	for (/[\s]*<line:.*[^\s].*>\n/ := classText) {
		lines = lines + line;
	}
	for (s <- [0..(size(lines)-7)])
	{
		chunks = chunks + <<class,s, 6>, lines[s..(s+6)]>;
	}
	return chunks;
}

list[list[tuple[loc, int, int]]] findDuplicates(chunks) {
	return groupDomainByRange(chunks);
}
