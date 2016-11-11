module volume

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;

int volume (model) {
	 //model = createM3FromEclipseProject(|project://SmallSQL/|);
	 return (0 | it + classVolume(c) | c <- classes(model));
}

int classVolume(class) {
	f = readFile(class);
	allCode = (0 | it + 1 | /.*[^\s].*\n/ := f); 
	comments = ([] | it+c | /<c:\/\*.*?\*\/>/s := f);
	int commentLineCount = 0;
	for (c <- comments)
	{
		commentLineCount = commentLineCount + (0 | it + 1 | /.*[^\s].*\n/ := c);
	}
	return allCode - commentLineCount;
}