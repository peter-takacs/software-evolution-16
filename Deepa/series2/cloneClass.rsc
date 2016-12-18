module cloneClass

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
classList = files(model);
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
list[tuple[loc cloneClass,str cloneCode, int lineNum]] code = [];
tuple[loc cloneClass,str cloneCode] codeClone = <|project://series2/src/tmp.txt|,"">;
list[tuple[loc cloneClass,str cloneCode, int lineNum]] codeTuples = [];
list[tuple[loc cloneClass,str cloneCode]] totalCode = [];
//list[loc] classNames = [];
list[tuple[loc cloneClass, int begin, int end]] classNames = [];
list[list[tuple[loc cloneClass, int begin, int end]]] classes = [];
loc largecloneClass = |project://series2/src/tmp.txt|;
reportPath = |project://series2/src/reportOveriew.txt|;
filePath = |project://series2/src/duplication.json|;
for(className<- classList){
file = readFileLines(className);
int j=0;
clone = className;
largecloneClass=className;
//codeTuples[0] = <className,"",0>;

for(line<-file){

if((/((\*|\/*)?[\n\r\t]*?\*)/ :=line)||(/^[ \t\r\n]*$/ := line)){
line="";
}
else{
//lineCount=lineCount+1;
code = code+<className,line,indexOf(file,line)>;
}
}
}



distMap = distribution(code.cloneCode);
for(codeLine<-code){
i = (distMap[codeLine.cloneCode]);
if(i >= 2){
codeTuples = codeTuples +<codeLine.cloneClass,codeLine.cloneCode,codeLine.lineNum>;
}

}

int i=0;
j = size(code);
int temp=0;
int tempEnd =0;
int duplicateLines =0;

while(i<size(codeTuples)){
if((codeTuples.cloneCode[i..(i+6)])==(code.cloneCode[indexOf(code.cloneCode,codeTuples.cloneCode[i])..((indexOf(code.cloneCode,codeTuples.cloneCode[i])+6))])){
 if(codeTuples.cloneClass[i] == (code.cloneClass[indexOf(code.cloneCode,codeTuples.cloneCode[i])])){
 code = code[(indexOf(code.cloneCode,codeTuples.cloneCode[i])+6)..];
 }
}
if((codeTuples.cloneCode[i..(i+6)])==(code.cloneCode[indexOf(code.cloneCode,codeTuples.cloneCode[i])..((indexOf(code.cloneCode,codeTuples.cloneCode[i])+6))])){
cloneClassuri = codeTuples.cloneClass[i];
cloneClassuri1 = code.cloneClass[indexOf(code.cloneCode,codeTuples.cloneCode[i])];
begin = code.lineNum[indexOf(code.cloneCode,codeTuples.cloneCode[i])];
end =  code.lineNum[indexOf(code.cloneCode,codeTuples.cloneCode[i])+6];
//tempBegin = indexOf(code.cloneCode,codeTuples.cloneCode[i]);
//tempEnd=tempBegin+6;

duplicateLines = duplicateLines+6;
cloneSize = cloneSize+6;
temp = i;
tempEnd = i+7;
count=7;
while((temp<size(codeTuples))&&(tempEnd<size(codeTuples))){

if((codeTuples.cloneCode[temp..tempEnd])==(code.cloneCode[indexOf(code.cloneCode,codeTuples.cloneCode[temp])..((indexOf(code.cloneCode,codeTuples.cloneCode[temp])+count))])){
duplicateLines = duplicateLines+1;
tempEnd = tempEnd+1;
cloneSize = cloneSize +1;
end = end+1;
i=tempEnd;
count=count+1;

}
else{
temp = size(codeTuples);

}


}
classNames = classNames + <cloneClassuri,begin,end>;
classNames = classNames + <cloneClassuri1,begin,end>;
remCode = code[tempEnd..];
//checks for same match in the remaining code
while(tempEnd < size(remCode)){
if((codeTuples.cloneCode[i..(i+6)])==(remCode.cloneCode[indexOf(remCode.cloneCode,codeTuples.cloneCode[i])..((indexOf(remCode.cloneCode,codeTuples.cloneCode[i])+6))])){
duplicateLines = duplicateLines+6;
beginRem = remCode.lineNum[indexOf(remCode.cloneCode,codeTuples.cloneCode[i])];
endRem = remCode.lineNum[indexOf(remCode.cloneCode,codeTuples.cloneCode[i])+6];
delBegin = beginRem;
delEnd = endRem;
cloneClassuri = remCode.cloneClass[beginRem];
classNames = classNames+<cloneClassuri,beginRem,endRem>;
if((cloneClassuri != code.cloneClass[indexOf(code.cloneCode,codeTuples.cloneCode[i])])){
classNames = classNames+<cloneClassuri1,beginRem,endRem>;
}

tempEnd = tempEnd+6;
remCode = remCode[endRem..];
}
tempEnd = tempEnd+1;
i =tempEnd+1;
classes = classes +[classNames];
}


}


if(largecloneSize<cloneSize){
largecloneSize = cloneSize;
}
cloneSize=0;

i=i+1;
}
writeToJson(classes);

//println("linecount and duplicate lines are <lineCount> , <duplicateLines>");
duplicatePercentage = ((duplicateLines*100)/j);
//println("duplicatepercentage is <duplicatePercentage>");
println("Largest clone size is <largecloneSize>");
println("Largest clone class is <largecloneClass>");

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
}

println("Rank is <rank>");*/


println(now());


}
void writeToJson(list[list[tuple[loc cloneClass, int begin, int end]]] classes)
{
   
    classes = dup(classes);
	loc file = |project://series2/result1.json|;
	s = "{\n\"groups\":[";
	for (group <- classes)
	{ count=0;
		s += "\n{\"classes\":[";
		for (range <- group)
		{
  		count=count+1;
		 if(range.begin!=0){
		 if(range.begin < range.end){
		 
		   println("count is <count>");
			s += "\n{\"uri\":\"<range.cloneClass>\",";
			s += "\n\"begin\":<range.begin>,";
			s += "\n\"end\":<range.end>\n";
			if(count < size(group)){
			println("less");
			s += "},";
			}
			else
			{
			s += "}";
			}
			}
			
		}
		}
		s += "\n]\n},";
	}
	s += "\n]\n}";
	writeFile(file, s);
}