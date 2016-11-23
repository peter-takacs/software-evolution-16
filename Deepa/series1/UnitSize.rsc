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
int totalSimpleRisk = 0;


for(i<- methodList){
count =0;
methodCodeLines = methodSize(i);
totalCount = totalCount + methodCodeLines;
totalMethods = totalMethods+1;
if((methodCodeLines<10)){
int totalSimpleRisk  = totalSimpleRisk+ methodCodeLines;
}
elseif(methodCodeLines<20){
totalModerateRisk = totalModerateRisk+ methodCodeLines;
}
elseif(methodCodeLines<50){
totalHighRisk = totalHighRisk+methodCodeLines;
}elseif(methodCodeLines>51){
totalveyHighRisk = totalveryHighRisk+methodCodeLines;
}
methodCodeLines=0;

}
avgLinecount =(totalCount/totalMethods);
avgSimpleRisk =0;
avgSimpleRisk = (100*totalSimpleRisk)/totalCount;
avgModerateRisk = (100*totalModerateRisk)/totalCount;
avgHighRisk = (100*totalHighRisk)/totalCount;
avgveryHighRisk = (100*totalveryHighRisk)/totalCount;
println("risks are <avgSimpleRisk> <avgModerateRisk> <avgveryHighRisk>");

risk = calculaterisk(avgLinecount);
rank = calculaterank(avgModerateRisk,avgHighRisk,avgveryHighRisk);

t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Total Line count in all the methods is <totalCount>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Total number of methods is  <totalMethods>", fontColor("black")),fillColor("gray")),
     	    box(text("Average unit size is <avgLinecount>", fontColor("black")),fillColor("gray")),
     	    box(text("<risk>", fontColor("black")),fillColor("gray")),
     	    box(text("<rank>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}




