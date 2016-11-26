module WritingToFile

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import vis::Figure;
import vis::Render;

void duplication(){

model = createM3FromEclipseProject(|project://smallSQL|);
classList = classes(model);
(lineCount(classList));
}



void lineCount(classList){
int duplicateCount=0;
int duplicateBlocks=0;
count =0;
int totalCount=0;
list[str] code=[];
list[str] totalCode = [];
loc cloneClass;
for(className<- classList){
file = readFileLines(className);
int j=0;
//list[loc] cloneClass = [];
cloneClass = className;

for(line<-file){
if((/((\*|\/*)?[\n\r\t]*?\*)/ :=line)||(/^[ \t\r\n]*$/ := line)){
line="";
}
else{
code = code+line;

}
}
}


distMap = distribution(code);

for(codeLine<-code){
i = (distMap[codeLine]);
if(i >= 2){
totalCode = totalCode +codeLine;
}

}

int i=0;
j = size(code);
int temp=0;
int tempEnd =0;
int duplicateLines =0;
filePath = |project://series2/src/duplication.txt|;
while(i<size(totalCode)){
if((totalCode[i..(i+6)])==(code[indexOf(code,totalCode[i])..((indexOf(code,totalCode[i])+6))])){
duplicateBlocks = duplicateBlocks+1;
duplicateLines = duplicateLines+6;
//cloneClass = cloneClass +className;
println("classname is <cloneClass>");
temp = i;
tempEnd = i+7;
while((temp<size(totalCode))&&((tempEnd)<size(totalCode))){
if((totalCode[temp..tempEnd])==(code[indexOf(code,totalCode[temp])..((indexOf(code,totalCode[temp])+7))])){
tempEnd = tempEnd+1;
duplicateLines = duplicateLines+1;
i=tempEnd;

appendToFile(filePath,[cloneClass]);
}
else{
temp = size(totalCode);
}

}
}
i=i+1;


}

duplicatePercentage = ((duplicateLines*100)/j);
str rank ="";
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





//appendToFile(filePath, i);



}

