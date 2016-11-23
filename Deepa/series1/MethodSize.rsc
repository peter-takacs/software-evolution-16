module MethodSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;

int calculateLines(unit){
methodCodeLines = methodSize(unit);
totalLinesofCode  = totalLinesofCode +methodCodeLines;
return totalLinesofCode;
}


int methodSize(method){
count =0;
countWhiteSpace =0;
countcommentlines=0;
file = readFileLines(method);
for(line<-file){
count = count + 1;
if((/^\\s*?$/:=line)||(/^[ \t\r\n]*$/ := line)){
countWhiteSpace = countWhiteSpace + 1;
}
elseif((/((\*|\/*)?[\n\r]*?\*)/ := line)||(/\/\/.*/:=line)){
countcommentlines = countcommentlines +1;
}
}
return (count-countWhiteSpace-countcommentlines);
}


str calculaterisk(avgComplexity){
str risk ="";
if(avgComplexity<10){
risk ="simple, without much risk" ;
}
else if(avgComplexity<20){
risk = "more complex, moderate risk";
}
else if(avgComplexity<50){
risk = "complex, high risk";
}
else{
risk = "untestable, very high risk";
}
return risk;
}


str calculaterank(avgModerateRisk,avgHighRisk,avgveryHighRisk){
str rank="";
if((avgModerateRisk <= 25)&&(avgHighRisk==0)&&(avgveryHighRisk==0)){
rank = "++";
}
else if((avgModerateRisk <=30)&&(avgHighRisk<=5)&&(avgveryHighRisk==0)){
rank = "+";
}
else if((avgModerateRisk <=40)&&(avgHighRisk<=10)&&(avgveryHighRisk==0)){
rank = "0";
}
else if((avgModerateRisk <=50)&&(avgHighRisk<=15)&&(avgveryHighRisk<=5)){
rank = "-";
}
else{
rank ="--";
}
return rank;
}

