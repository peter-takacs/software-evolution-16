module dup

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import DateTime;
import vis::Figure;
import vis::Render;

void duplication(){
println(now());
model = createM3FromEclipseProject(|project://smallSQL|);
classList = classes(model);
(lineCount(classList));
}



void lineCount(classList){
int duplicateCount=0;
int duplicateBlocks=0;
count =0;
int lineCount=0;
int totalCount=0;
int largecloneSize = 0;
int cloneSize = 0;
int begin=0;
int end=0;

loc clone = |project://series2/src/tmp.txt|;
//list[str] code=[];
list[tuple[loc cloneClass,str cloneCode]] code = [<|project://series2/src/|,"">];
tuple[loc cloneClass,str cloneCode] codeClone = <|project://series2/src/tmp.txt|,"">;
list[tuple[loc cloneClass,str cloneCode]] codeTuples = [<|project://series2/src/|,"">];
list[tuple[loc cloneClass,str cloneCode]] totalCode = [<|project://series2/src/tmp.txt|,"">];
//list[loc] classNames = [];
list[tuple[loc cloneClass, int begin, int end]] classNames = [<|project://series2/src/tmp.txt|,0,0>];;
loc largecloneClass = |project://series2/src/tmp.txt|;
reportPath = |project://series2/src/reportOveriew.txt|;
filePath = |project://series2/src/duplication.txt|;
for(className<- classList){
file = readFileLines(className);
int j=0;
clone = className;
largecloneClass=className;
codeTuples[0] = <className,"">;

for(line<-file){

if((/((\*|\/*)?[\n\r\t]*?\*)/ :=line)||(/^[ \t\r\n]*$/ := line)){
line="";
}
else{
//lineCount=lineCount+1;
code = code+<className,line>;
}
}
}



distMap = distribution(code.cloneCode);
for(codeLine<-code){
i = (distMap[codeLine.cloneCode]);
if(i >= 2){
codeTuples = codeTuples +<codeLine.cloneClass,codeLine.cloneCode>;
}

}

int i=0;
j = size(code);
int temp=0;
int tempEnd =0;
int duplicateLines =0;

while((i<size(codeTuples))){

if((codeTuples.cloneCode[i..(i+6)])==(code.cloneCode[indexOf(code.cloneCode,codeTuples.cloneCode[i])..((indexOf(code.cloneCode,codeTuples.cloneCode[i])+6))])){
cloneClassuri = codeTuples.cloneClass[i];
println((codeTuples[i]).cloneClass);
//appendToFile(filePath,cloneClassuri);
//begin = indexOf(code.cloneCode,codeTuples.cloneCode[i]);

classNames = classNames+<cloneClassuri,i,(i+6)>;

duplicateLines = duplicateLines+6;
cloneSize = cloneSize+6;
temp = i;
tempEnd = i+7;
while((temp<size(codeTuples))&&(tempEnd<size(codeTuples))){

if((codeTuples.cloneCode[temp..tempEnd])==(code.cloneCode[indexOf(code.cloneCode,codeTuples.cloneCode[temp])..((indexOf(code.cloneCode,codeTuples.cloneCode[temp])+7))])){
duplicateLines = duplicateLines+1;
tempEnd = tempEnd+1;
cloneSize = cloneSize +1;

i=tempEnd;

}
else{
temp = size(codeTuples);

}


}
//end = (indexOf(code.cloneCode,codeTuples.cloneCode[i]));

}


if(largecloneSize<cloneSize){
largecloneSize = cloneSize;
largecloneClass=(codeTuples[i]).cloneClass;
//begin = i-cloneSize;
//end=i;
}
cloneSize=0;
i=i+1;
}
writeToJson(classNames);

println("linecount and duplicate lines are <lineCount> , <duplicateLines>");
duplicatePercentage = ((duplicateLines*100)/j);
println("duplicatepercentage is <duplicatePercentage>");
println("Largest clone size is <largecloneSize>");
println("Largest clone class is <largecloneClass>");

//str report = "Duplicate percentage is <duplicatePercentage>\n";
//report = report+("Largest clone size is <largecloneSize>");
//report= report +("Largest clone class is <largecloneClass>");
//appendToFile(reportPath,report);

/*str rank ="";
if(duplicatePercentage < 3){
rank = "++";
}
else if(duplicatePercentage < 5){
rank = "+";
}
else if(duplicatePercentage < 10){
rank = "0";
}
else if(duplicatePercentage < 20){
rank = "-";
}
else{
rank = "--";
}*/





//appendToFile(filePath, i);
println(now());


}
void writeToJson(list[tuple[loc cloneClass, int begin, int end]] classNames)
{
	loc file = |project://series2/duplication.txt|;
	s = "{\n\"groups\":[";
	//for (group <- duplicates)
	//{
		s += "\n{\"classes\":[";
		for (range <- classNames)
		{
			s += "\n{\"uri\":\"<range>\",";
			s += "\n\"begin\":<range.begin>,";
			s += "\n\"end\":<range.end>\n";
			s += "},";
		}
		s += "\n{}]\n},";
	//}
	//s += "{}\n]\n}";
	writeFile(file, s);
}
