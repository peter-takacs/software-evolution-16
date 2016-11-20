module MethodSize

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;

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

