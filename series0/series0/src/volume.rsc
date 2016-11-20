module volume

import lang::java::jdt::m3::Core;
import IO;
import String;
import lang::java::m3::Core;
import vis::Figure;
import vis::Render;
import util::Math;

int volume (model) {
	 //model = createM3FromEclipseProject(|project://SmallSQL/|);
	 return (0 | it + classVolume(c) | c <- classes(model));
}

Figure visTree(loc root, rel[loc from, loc to] containments)
{
	return tree(box(text(root.uri + "\n" + toString(lines(root))), fillColor("blue")), [visTree(g,containments) | g<-containments[root]], std(gap(20)));
}

void drawTree(M3 model)
{
	render(tree(box(text("SmallSQL")), [visTree(cls, model@containment) | cls <- classes(model)]));
}

void drawVolumeTree(model)
{
	
	b = box(text("alma"), gap(2), fillColor("lightyellow"));
	render(b);
}

int lines(elem) {
	f = readFile(elem);
	allCode = (0 | it + 1 | /.*[^\s].*\n/ := f); 
	comments = ([] | it+c | /<c:\/\*.*?\*\/>/s := f);
	int commentLineCount = 0;
	for (c <- comments)
	{
		commentLineCount = commentLineCount + (0 | it + 1 | /.*[^\s].*\n/ := c);
	}
	return allCode - commentLineCount;
}