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
countperthousand=0;
//Total line count is the the line count of code lines in the entire project 
//totalCount = lineCount(classList)-countWhiteandblankspaces(classList)-countComments(classList);
totalCount = lines(classList);


countperthousand= totalCount/1000;
if(countperthousand<66){
 prjSize="very small Size";
 rank = "Rank is ++" ;
 }
 elseif(countperthousand<= 246){
 prjSize = "Small Size";
 rank ="Rank is +";
 }
 elseif(countperthousand<=665){
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
t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Line count is <totalCount>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Size of the system is <prjSize>", fontColor("black")),fillColor("gray")),
     	     box(text("Rank is <rank>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}

int lines(classList){
count =0;
countWhiteSpace =0;
countcommentlines=0;
for(i<- classList){
file = readFileLines(i);
for(line<-file){
count = count + 1;
if((/^\\s*?$/:=line)||(/^[ \t\r\n]*$/ := line)){
countWhiteSpace = countWhiteSpace + 1;
}
elseif((/((\*|\/*)?[\n\r]*?\*)/ := line)||(/\/\/.*/:=line)){
countcommentlines = countcommentlines +1;
}
}
}
return (count-countWhiteSpace-countcommentlines);
}



