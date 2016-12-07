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

loc clone = |project://series2/src/tmp.txt|;
list[str] code=[];
tuple[loc cloneClass,str cloneCode] codeClone = <|project://series2/src/tmp.txt|,"">;
list[tuple[loc cloneClass,str cloneCode]] codeTuples = [<|project://series2/src/|,"">];
list[tuple[loc cloneClass,str cloneCode]] totalCode = [<|project://series2/src/tmp.txt|,"">];
list[loc] classNames = [];
list[loc] cloneClassuri = [];
filePath = |project://series2/src/duplication.txt|;
for(className<- classList){
file = readFileLines(className);
int j=0;
clone = className;
codeTuples[0] = <className,"">;

for(line<-file){

if((/((\*|\/*)?[\n\r\t]*?\*)/ :=line)||(/^[ \t\r\n]*$/ := line)){
line="";
}
else{
//lineCount=lineCount+1;
code = code+line;
}
}
}



distMap = distribution(code);
for(codeLine<-code){
i = (distMap[codeLine]);
if(i >= 2){
codeTuples = codeTuples +<clone,codeLine>;
}

}

int i=0;
j = size(code);
int temp=0;
int tempEnd =0;
int duplicateLines =0;

while((i<size(codeTuples))){
if((codeTuples.cloneCode[i..(i+6)])==(code[indexOf(code,codeTuples.cloneCode[i])..((indexOf(code,codeTuples.cloneCode[i])+6))])){
//if((codeTuples.cloneCode[i..(i+6)]) < (codeTuples.cloneCode[i+6..])){
cloneClassuri = (codeTuples[i]).cloneClass;
classNames = classNames+cloneClassuri;

duplicateLines = duplicateLines+6;
temp = i;
tempEnd = i+7;
while((temp<size(codeTuples))&&(tempEnd<size(codeTuples))){

//if((codeTuples.cloneCode[temp..tempEnd])==(codeTuples.cloneCode[tempEnd..(tempEnd+6)])){
if((codeTuples.cloneCode[temp..tempEnd])==(code[indexOf(code,codeTuples.cloneCode[temp])..((indexOf(code,codeTuples.cloneCode[temp])+7))])){
duplicateLines = duplicateLines+1;
tempEnd = tempEnd+1;

i=tempEnd;

}
else{
temp = size(codeTuples);

}


}
}

i=i+1;
if(largecloneSize<tempEnd);
largecloneSize = tempEnd;

}
cloneClassuri = dup(cloneClassuri);
appendToFile(filePath,cloneClassuri);
println("linecount and duplicate lines are <lineCount> , <duplicateLines>");
duplicatePercentage = ((duplicateLines*100)/j);
println("duplicatepercentage is <duplicatePercentage>");
println("Largest clone size is <largecloneSize>");
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

