# Approach

## Volume

For the _volume_ metric, we simply need to calculate the number of lines
in the source code. To that end, we use the 
`import lang::java::jdt::m3::Core;` and `import lang::java::m3::Core;` modules from Rascal.
We create an M3 model from our Eclipse project, and pass that to the
`volume` function in the `volume.rsc` file.

This aggregates the computed volume over all files in the project.
To count the lines, we read each file, then count all lines excluding whitespace using a regex and Rascal's pattern matcing:

`(0 | it + 1 | /.*[^\s].*\n/ := file)`

Afterwards, we count the lines in the file that are comments of the form // or /* */, using another regex.

### Volume tree
Using Rascal's builtin `vis` package, we can draw a tree structure that shows how the volume is distributed among the classes and methods of the project.
For this, we can make use of the `tree` primitive in `vis`, and the `containment` annotation of the M3 model.
For each class in the project, we can use `containment` to determine the methods contained in it, then compute their volume, and pass that on to the constructor of the `tree` object.

To calculate this metric, import the `volume` module and call the `volume(model)` method, passing an M3 model to it.

## Unit size

For computing the unit size, we can use the same method that we've been using for computing the volume.
To create a risk grading table for unit size, we looked at the average unit size of methods whose risk was in the given category based on their complexity scores.
Thus, for grading the risk of a given method based on unit size, we devised the following categories:

|Risk profile | Unit size |
--------------|------------
Moderate      | 125 <
High          | 150 <
Extreme       | 200 <

After that we can use the same lookup table as with code complexity.

To calculate this metric, import the `unitSize` module and call the `aggregateRiskLineRatios(model)` method. 
This returns a map telling what percentage of the code is in a moderate, high and extreme risk category. 

## Complexity

For measuring code complexity, we created an AST for each of the methods in the project, then used rascal's `visit` statement to traverse all the nodes.
Afterwards, we used the lookup table in the paper to determine the risk category of each method and sum up the results.

To calculate this metric, import the `complexity` module and call the `aggregateUnitRiskLineRatios(model)` method. 
This returns a map telling what percentage of the code is in a moderate, high and extreme risk category.

## Duplication

For duplication, we first read the source code of the whole project into a list containing `[loc, str]` tuples, each location pointing to a given line.
This was necessary because exact string match was required for duplication search.
Afterwards, we grouped the lines to get a `list[list[loc]]`, where each `list[loc]` is a list of locations, where the same line might appear.
We then iterate through these groups, and try to grow them as large as possible by adding one line at a time to the `loc` object contained within.
This is done with the help of the `list[tuple[loc, str]]` object, since it also doubles as a lookup table.
Once this is done, we can compute the total number of lines that are duplicated in the code.

Importing the `duplication` module and calling `findDuplicateChunksInProject(model)` gives you a list of lists, containing locations, which each point to a duplicated chunk of code.
For grading, the `gradeDuplication(model)`shall be used.

# Results

## Volume

The project without whitespace is a grand total of 23703 lines.

**Grade**: ++

## Unit size

|Complexity|Percentage|
-----------|-----------
|Moderate  | 0.62     |
|High      | 2.19     |
|Extreme   | 3.51     |

 Low complexity is all the rest. As there are `extreme` lines, the grade cannot be better than `-`, but it will also not get any worse, since the percentages of moderate and high are negligible, and extreme doesn't surpass 5%.

 **Grade**: -

## Complexity

|Complexity|Percentage|
-----------|-----------
|Moderate  | 5.36     |
|High      | 3.49     |
|Extreme   | 0.76     |

Based on cyclomatic complexity, there are less `extreme` methods, but there still are a few at least, meaning the the grade is a `-` at best.

**Grade**: -

## Duplication

A total of `81` groups have been identified that are at least 6 lines long and appear more than once.
That corresponds to `1701` lines of code, giving a `7.17%` duplication rate.

**Grade**: o

## Overall

|             | Volume | Complexity | duplication | Unit size | **Overall** |
|-------------|--------|------------|-------------|-----------|-------------|
|**grade**    | ++     | -          | o           | -         |
|analysability| ++     |            | o           | -         | **+**
|changeability|        | -          | o           |           | **-**
|testability  |        | -          |             | -         | **-**