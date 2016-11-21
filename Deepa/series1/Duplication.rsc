module Duplication


import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import String;
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
for(i<- classList){
file = readFileLines(i);
int j=0;
str rank = "";


//list[list[str]] totalCode = [];
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
int duplicateLines =0;
while(i<size(totalCode)){
if((totalCode[i..(i+6)])==(code[indexOf(code,totalCode[i])..((indexOf(code,totalCode[i])+6))])){
duplicateBlocks = duplicateBlocks+1;
duplicateLines = duplicateLines+6;

temp = i;

while((temp<size(totalCode))&&((temp+6)<size(totalCode))){
if((totalCode[temp..(temp+6)])==(code[indexOf(code,totalCode[temp])..((indexOf(code,totalCode[temp])+6))])){
temp = temp+1;
duplicateLines = duplicateLines+1;
i=temp;
}
else{
temp = size(totalCode);
}

}
}
i=i+1;


}
duplicatePercentage = ((duplicateLines*100)/j);
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
t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Total Line count is <i>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Total number of duplicate lines are <duplicateLines>", fontColor("black")),fillColor("gray")),
     	    box(text("Duplicate percentage is <duplicatePercentage>", fontColor("black")),fillColor("gray")),
     	    box(text("Rank is <rank>", fontColor("black")),fillColor("gray"))
   
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);
}

