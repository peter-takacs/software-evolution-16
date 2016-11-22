module UnitSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import vis::Figure;
import vis::Render;
import List;
import MethodSize;

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
methodCodeLines = methodSize(i);
totalCount = totalCount + methodCodeLines;
totalMethods = totalMethods+1;
}
avgLinecount =(totalCount/totalMethods);
risk = calculaterisk(avgLinecount);

t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Total Line count in all the methods is <totalCount>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Total number of methods is  <totalMethods>", fontColor("black")),fillColor("gray")),
     	    box(text("Average unit size is <avgLinecount>", fontColor("black")),fillColor("gray")),
     	    box(text("<risk>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}




