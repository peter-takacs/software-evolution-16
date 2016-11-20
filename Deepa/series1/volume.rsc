module volume

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import IO;
import List;
import vis::Figure;
import vis::Render;

void volume(){
model = createM3FromEclipseProject(|project://smallsQL|);
classList = classes(model);
totalCount=0;
str prjSize="";
str rank = "";
//Total line count is the the line count of code lines in the entire project 
totalCount = lineCount(classList)-(countWhiteandblankspaces(classList)+countComments(classList));
//println("Line count is <totalCount>");


totalCount= totalCount/1000;
if(totalCount<66){
 prjSize="very small Size";
 rank = "Rank is ++" ;
 }
 elseif((66< totalCount)&&(totalCount<= 246)){
 prjSize = "Small Size";
 rank ="Rank is +";
 }
 elseif((246<totalCount)&&(totalCount<=665)){
 prjSize ="Medium Size";
 rank ="Rank is 0";
 }
 elseif((665<totalCount)&&(totalCount<=1310)){
 prjSize="High Size";
 rank ="Rank is -";
 }
 else{
 prjSize="A very High size";
 rank = "Rank is --";
 }
 //Visual display of the output
//render(box(text("Line count is <totalCount>\n Size of the system is <prjSize>\n Rank is <rank>", fontColor("white")), fillColor("blue"),size(50,50)));
t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Line count is <totalCount>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Size of the system is <prjSize>", fontColor("black")),fillColor("gray")),
     	     box(text("Rank is <rank>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}

//Counts all lines in the project
int lineCount(classList){
count =0;
for(i<- classList){
file = readFileLines(i);
count = count + size(file);
}
return count;
}

//counts whitelines and blank spaces
int countWhiteandblankspaces(classList){
countWhiteSpace =0;
for(i<- classList){
file = readFileLines(i);
for(line<-file){
if(/^[ \t\r\n]*$/ := line)
countWhiteSpace = countWhiteSpace + 1;
}
return countWhiteSpace;
}
}
//counts comment lines.
int countComments(classList){
c =0;
for(i<- classList){
file = readFileLines(i);
for(commentLine <- file){
if(/((\*|\/*)?[\n\r]*?\*)/ := commentLine)
c = c +1;
}
return c;
}

}


