module volume

import lang::java::jdt::m3::Core;
import IO;
import lang::java::m3::Core;

list volume () {
	 model = createM3FromEclipseProject(|project://SmallSQL/|);
	 classFiles = [squeeze(readFile(c), " \t") | c <- classes(model)];
	 lines = 0;
	 for (string file <- classFiles) {
	 	lines += (0 | it + 1 | /.*\n/ := file)
	 }
}