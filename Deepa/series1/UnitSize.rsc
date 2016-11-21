module UnitSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import MethodSize;
import vis::Figure;
import vis::Render;
import List;

void unitSize(){
model = createM3FromEclipseProject(|project://smallSQL|);
methodList = methods(model);
totalCount =0;
totalMethods=0;
str risk = "";
int totalModerateRisk = 0;
int totalHighRisk = 0;
int totalveryHighRisk=0;
int totalRisk =0;
int avgModerateRisk =0;
int avgHighRisk=0;
int avgveryHighRisk=0;
str rank="";
int totalLinesofCode=0;

for(i<- methodList){
count =0;
//file = readFileLines(i);
//count = size(file);
methodCodeLines = methodSize(i);
totalCount = totalCount + methodCodeLines;
totalMethods = totalMethods+1;


}
avgLinecount =(totalCount/totalMethods);

if(avgLinecount<10){
risk ="simple, without much risk" ;
}
else if((avgLineCount>11)&&(avgLineCount<20)){
risk = "more complex, moderate risk";
}
else if((avgLineCount>21)&&(avgLineCount<50)){
risk = "complex, high risk";
}
else{
risk = "untestable, very high risk";
}

//render(box(text("Average linecount in all the methods is <avgLinecount>", fontColor("white")), fillColor("mediumblue"),grow(1.2)));
t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Total Line count is <totalCount>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Total number of methods is  <totalMethods>", fontColor("black")),fillColor("gray")),
     	    box(text("Average unit size is <avgLinecount>", fontColor("black")),fillColor("gray")),
     	    box(text("<risk>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}

/*Output
Line count is 31732
very small Size
Rank is ++
ok
*/



