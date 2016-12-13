# Series2

## Preprocessing

For duplication, we first read the source code of the whole project into a list containing `[loc, str]` tuples, each location pointing to a given line.
During this, we sanitize the files, meaning we remove all single-line and multi-line comments from the source, along with all empty lines. We also compress whitespace so that differences that are only in spacing do not affect comparing the lines.

We want that the lines numbers we display in the report map to the actual line numbers, so for each `line` object we store two line numbers: one that is an "absolute" line number, i.e. the original line number, and one that is a "sanitized" line number, which is in fact the number of the line in the file _if we discard comments and whitespace_.

We also calculate a hash for each line, and store that along with the location and original line. This makes it easier for computationally intensive tasks to run on the dataset (e.g: grouping, lookup). In the end, we store the lines in a map, indexed by their location.

## Grouping  

Afterwards, we group the lines to get a `list[list[loc]]`, called `g` from here on, where each `list[loc]` is a list of locations, where the same line might appear. This means, that if a given line appears in `fileA`, `fileB` and `fileC`, there will be an element `[fileA:lineNrA, fileB:lineNrB, fileC:lineNrC]` in `g`. 

## Growing groups

We iterate through `g`, and try to grow them as large as possible by adding one line at a time to the `loc` object contained within. For each group, we look at the next line of the members, and if each one of those is still the same, we append them to the lines we're looking at. This way, we keep adding lines to each member or `g` until we encounter lines that do not match up. If the growing operation could be continued by dropping some lines from the group, we do that, because in the end result it usually means a larger detected clone percentage. This however is configurable easily. 

## Deleting overlapping clones

We also have a method, where, after the growing phase is done, we remove overlapping clones. If we find two clone groups, which have the same number of entries and the same files, _and_ they have overlapping line numbers, we drop the group with the smaller number of lines.

Once this is done, we can compute the total number of lines that are duplicated in the code, after filtering on minimal length.

## Post-processing and presentation

Once we have our list of duplicates, we have a method to write the result into a .json file for presentation purposes. For presenting our result, we chose to use HTML and JavaScript, more specifically the D3.js framework. In broad strokes, we fetch the output.json file, containing an enumeration of clone groups through an AJAX web request, then pass on these data to the d3 framework.

First, we transform the dataset into a set of nodes and a list of edges. Each node will represent a class in the project, and each edge will mean that there is code in the two endpoints that is shared. The larger the clone, the more weight the edge gets. We then feed these edges to d3, creating an interactive graph of classes.

In addition to that, we also make each of the nodes clickable: after a node has been selected, we launch another AJAX request to fetch the relevant parts of the source code and display them next to the graph.

## Testing

In order for our algorithm to be verifiable, we created a `TestHarness` java project, which consists of three hand-crafted classes. They are small, but were created with edge cases in mind: field, methods, partially overlapping clones, single- and multi-line comments. Due to the size of the classes, the output of the algorithm is easily verifiable manually, and can also be compared to earlier results if stored to a .json file, thus enabling us to do regression testing.