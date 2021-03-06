module volume

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;
import vis::Figure;
import vis::Render;
import util::Math;

str getGrade(model)
{
	int vol = volume(model);
	if (vol < 66000) return "++";
	if (vol < 246000) return "+";
	if (vol < 665000) return "o";
	if (vol < 1310000) return "-";
	return "--";
}

int volume(model) {
	 return (0 | it + countLines(c) | c <- classes(model));
}

Figure visTree(loc root, rel[loc from, loc to] containments)
{
	return tree(box(text(root.uri + "\n" + toString(lines(root))), fillColor("blue")), 
		[visTree(g,containments) | g<-containments[root], g.scheme == "java+class" || g.scheme == "java+method"], std(gap(20)));
}

void drawTree(M3 model)
{
	render(tree(box(text("SmallSQL")), [visTree(cls, model@containment) | cls <- classes(model)]));
}

int countLines(elem) {
	f = readFile(elem);
	allCode = (0 | it + 1 | /.*[^\s].*\n/ := f); 
	comments = ([] | it+c | /<c:\/\*.*?\*\/>/s := f);
	singleLineComments = (0 | it + 1 | /<c:\/\/.*>/ := f);
	int commentLineCount = 0;
	for (c <- comments)
	{
		commentLineCount = commentLineCount + (0 | it + 1 | /.*[^\s].*\n/ := c);
	}
	return allCode - commentLineCount - singleLineComments;
}