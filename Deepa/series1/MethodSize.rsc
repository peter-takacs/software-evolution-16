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
totalCount = lineCount(method)-(countWhiteandblankspaces(method)+countComments(method));
return totalCount;
}
//Counts all lines in the project
int lineCount(method){
count =0;
file = readFileLines(method);
count = size(file);
return count;
}

//counts whitelines and blank spaces
int countWhiteandblankspaces(method){
countWhiteSpace =0;
file = readFileLines(method);
for(line<-file){
if(/^[ \t\r\n]*$/ := line)
countWhiteSpace = countWhiteSpace + 1;
}
return countWhiteSpace;
}
//counts comment lines.
int countComments(method){
c =0;

file = readFileLines(method);
for(commentLine <- file){
if(/((\*|\/*)?[\n\r]*?\*)/ := commentLine)
c = c +1;
}
return c;
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

