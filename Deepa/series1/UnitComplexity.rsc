module UnitComplexity
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import List;
import MethodSize;
import vis::Figure;
import vis::Render;

void complexity(){
myModel = createM3FromEclipseProject(|project://smallSQL|);
methodList = methods(myModel);
 

methodCount=0;
int avgComplexity=0;
int totalComplexity = 0;
avgComplexity = 0;
int totalSimpleRisk = 0;
int totalModerateRisk = 0;
int totalHighRisk = 0;
int totalveryHighRisk=0;
int totalRisk =0;
int avgModerateRisk =0;
int avgHighRisk=0;
int avgveryHighRisk=0;
str rank="";
str risk="";
int totalLinesofCode=0;
for(i<- methodList){
a = getMethodASTEclipse(i,model=myModel);
//print("method <i> \n");
int complexity =0;
int methodCodeLines=0;
for(ast<-a){
//initially used if, for, case,do,while . But found other statemts in the website below
//Used different types of statements from http://stackoverflow.com/questions/40064886/obtaining-cyclomatic-complexity
    visit (ast) {
        case \if(_,_) : complexity += 1;
        case \if(_,_,_) : complexity += 1;
        case \case(_) : complexity += 1;
        case \do(_,_) : complexity += 1;
        case \while(_,_) : complexity += 1;
        case \for(_,_,_) : complexity += 1;
        case \for(_,_,_,_) : complexity += 1;
        case foreach(_,_,_) : complexity += 1;
        case \catch(_,_): complexity += 1;
        case \conditional(_,_,_): complexity += 1;
        case infix(_,"&&",_) : complexity += 1;
        case infix(_,"||",_) : complexity += 1;
                
    }
  }

totalComplexity = totalComplexity +complexity;
methodCount = methodCount+1;
methodCodeLines = methodSize(i);
if((complexity<10)){
int totalSimpleRisk  = totalSimpleRisk+ methodCodeLines;
totalLinesofCode  = totalLinesofCode +methodCodeLines;
}
if((complexity>10)&&(complexity<20)){
totalModerateRisk = totalModerateRisk+ methodCodeLines;
totalLinesofCode  = totalLinesofCode +methodCodeLines;
}
elseif((complexity>21)&&(complexity<50)){
totalHighRisk = totalHighRisk+methodCodeLines;

totalLinesofCode  = totalLinesofCode + methodCodeLines;
}elseif((complexity>50)){
totalveyHighRisk = totalveryHighRisk+methodCodeLines;
totalLinesofCode  = totalLinesofCode +methodCodeLines;
}
compelxity=0;

}
//calculate average complexity
avgComplexity = (totalComplexity/methodCount);


avgModerateRisk = (100*totalModerateRisk)/totalLinesofCode;
avgHighRisk = (100*totalHighRisk)/totalLinesofCode;
avgveryHighRisk = (100*totalveryHighRisk)/totalLinesofCode;

if(avgComplexity<10){
risk ="simple, without much risk" ;
}
else if((avgComplexity>11)&&(avgComplexity<20)){
risk = "more complex, moderate risk";
}
else if((avgComplexity>21)&&(avgComplexity<50)){
risk = "complex, high risk";
}
else{
risk = "untestable, very high risk";
}


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

t1 = tree(box(text("SmallSQL", fontColor("black")),fillColor("gray")),
          [ box(text("Total complexity is <totalComplexity>\n ", fontColor("black")),fillColor("gray")),
     	    box(text("Total number of methods is  <methodCount>", fontColor("black")),fillColor("gray")),
     	    box(text("Average complexity is  <avgComplexity>", fontColor("black")),fillColor("gray")),
     	  
     	    box(text("Risk is <risk>", fontColor("black")),fillColor("gray")),
     	    box(text("Rank is <rank>", fontColor("black")),fillColor("gray"))
     	  ],
          std(size(50)), std(gap(20))
    	);
render(t1);

}

