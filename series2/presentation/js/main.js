var MIN_WEIGHT = 5;
var PREAMBLE_WIDTH = 2;

function buildForces(svg, width, height) {
    
        let manyBodyForce = d3.forceManyBody();
        manyBodyForce.strength(_ => -10);

        let centerForce = d3.forceCenter(width / 2, height / 2);

        return simulation = d3.forceSimulation()
            .force("link", d3.forceLink().id(function(d) { return d.id; }))
            .force("charge", manyBodyForce)
            .force("center", centerForce);
}

function buildLinks(svg, graph) {
    return svg.append("g")
            .attr("class", "links")
            .selectAll("line")
            .data(graph.links)
            .enter().append("line")
            .attr("stroke-width", function(d) { return Math.sqrt(d.value); });
}

function onNodeSelected(el, graph, groups, edgeMap, node)
{   
    d3.select("#sidebar").classed("hidden", false);

    for (let n of graph.nodes)
    {
        n.isSelected = false;
        n.isSecondary = false;
    }

    el.isSelected = true;

    document.querySelector(".selected-class").textContent = el.id.split("/").pop();

    updateList(getClones(el.id, groups));

    //let neighboringNodes = graph.nodes.filter(n => Array.from(edgeMap.get(el.id)).map(i => i[0]).includes(n.id));
    let neighboringNodes = graph.nodes.filter(n => graph.links.some(e => (e.source.id == el.id && e.target.id == n.id) || (e.source.id == n.id && e.target.id == el.id)));
    for (let neighbor of neighboringNodes)
    {
        neighbor.isSecondary = true;
    }


    node.data(graph.nodes)
        .classed("nodes", true)
        .classed("selected", d=>d.isSelected)
        .classed("secondary", d=>d.isSecondary);
}

function getClones(cls, groups) 
{
    let result = [];
    for (let group of groups)
    {
        if (group === undefined || group.classes == undefined) continue;
        if (group.classes.some(e => e.uri == cls && e.length > MIN_WEIGHT))
        {
            result.push({source: group.classes.find(e => e.uri == cls), target: group.classes.filter(e => e.uri !== undefined)});
        }
    }
    return result;
}

function updateList(nodes)
{
    var divs = d3.select("#has-common").selectAll(".source")
        .data(nodes);

    var entered = divs.enter().append("div")
        .classed("source", true)
        .text(d => d.source.uri.split("/").pop() + " " + d.source.begin + "-" + d.source.end)
        .on("click", onSourceLocationClicked);
        
    entered.selectAll("div")
        .data(d => d.target)
        .enter().append("div")
            .classed("target", true)                        
            .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end)
            .on("click", onTargetLocationClicked);

    divs.classed("source", true)
        .text(d => d.source.uri.split("/").pop() + " " + d.source.begin + "-" + d.source.end)
            .selectAll("div")
                .data(d => d.target)
                .enter().append("div")
                    .classed("target", true)                        
                    .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end)
                    .on("click", onTargetLocationClicked);   
        
    divs.exit().remove();       
}

function updateLarges(classes)
{
    var divs = d3.select("#largest-clone").selectAll("div")
        .data(classes);

    var entered = divs.enter().append("div")
        .classed("target", true)
        .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end)
        .on("click", onTargetLocationClicked);
            

    divs.classed("source", true)
        .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end);
        
    divs.exit().remove();           
}

function onSourceLocationClicked(d) {
    var locs = d.target;
    Promise.all(locs.map(l => fetch(l.uri.substring(l.uri.indexOf("smallsql"))))).then(rs => {
        Promise.all(rs.map(r => r.text())).then(ts => updateSourceView(ts, locs));
    });
}

function onTargetLocationClicked(loc)
{
    fetch(loc.uri.substring(loc.uri.indexOf("smallsql"))).then(r => {
        r.text().then(t => updateSourceView([t], [loc]));
    });
}


function updateSourceView(ts, locs)
{
    let sources = ts.map((el, idx) => {return {text: el, location: locs[idx]}});
    let divData = d3.select("#source-view")
        .selectAll("code")
        .data(sources);
    
    //entered
    let enteredDivs = divData.enter()
        .append("code")
        .classed("view", true);

    enteredDivs
        .insert("pre")
            .classed("prettyprinted", false)
            .classed("prettyprint", true)            
            .classed("preamble", true)
            .text(preamble);
    enteredDivs
        .insert("pre")
            .classed("prettyprinted", false)
            .classed("prettyprint", true)            
            .classed("important", true)
            .text(relevantLines);
    enteredDivs
        .insert("pre")
            .classed("prettyprinted", false)
            .classed("prettyprint", true)            
            .classed("postfix", true)
            .text(postfix);

    

    //updated
    divData.select("pre.preamble")
        .text(preamble)
    divData.select("pre.important")
        .text(relevantLines)
    divData.select("pre.postfix")
        .text(postfix)

    //exited
    divData.exit().remove();


    PR.prettyPrint();
}

function preamble(source)
{
    lines = source.text.split("\n");
    let relevantLines = lines.slice(source.location.begin-PREAMBLE_WIDTH-2, source.location.begin-2)
        .map((line,idx) => (idx + source.location.begin-PREAMBLE_WIDTH) + line)
        .join("\n");
    return relevantLines;
}

function relevantLines(source)
{
    lines = source.text.split("\n");
    let relevantLines = lines.slice(source.location.begin-1, source.location.end)
        .map((line,idx) => (idx + source.location.begin) + line)
        .join("\n");
    return relevantLines;
}

function postfix(source)
{
    lines = source.text.split("\n");
    let relevantLines = lines.slice(source.location.end, source.location.end+1+PREAMBLE_WIDTH)
        .map((line,idx) => (idx + source.location.end+1) + line)
        .join("\n");
    return relevantLines;
}

function ticked(link, node)
{
    const width = 500;
    const height = 500;
    const radius = 6;
    link
        .attr("x1", function(d) { return d.source.x; })
        .attr("y1", function(d) { return d.source.y; })
        .attr("x2", function(d) { return d.target.x; })
        .attr("y2", function(d) { return d.target.y; });

    node.attr("cx", function(d) { return d.x = Math.max(radius, Math.min(width - radius, d.x)); })
        .attr("cy", function(d) { return d.y = Math.max(radius, Math.min(height - radius, d.y)); });
}

function dragstarted(d, simulation) {
    if (!d3.event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x;
    d.fy = d.y;
}

function dragged(d, simulation) {
    d.fx = d3.event.x;
    d.fy = d3.event.y;
}

function dragended(d, simulation) {
    if (!d3.event.active) simulation.alphaTarget(0);
    d.fx = null;
    d.fy = null;
}

function removeIsolatedNodes(g)
{
    let nodes = g.nodes.filter(e => g.links.some(l => l.source == e.id || l.target == e.id));
    return {nodes:nodes, links: g.links};
}

function createGraphObject(j) {
    return {nodes: getClasses(j), links: getEdgeList(getEdges(j))};
}

function getEdgeList(edgeMap)
{
    return Array.from(edgeMap).map(e => {
        return Array.from(e[1]).map(t => {return {source: e[0], target: t[0], value: t[1]}});
    }).reduce((accumulator, currentValue) => accumulator.concat(currentValue), []);
}

function getEdges(j)
{
    let groups = j.groups;
    let edges = new Map();
    for (let group of groups)
    {
        for (let clsA of group.classes)
        {
            for (let clsB of group.classes)
            {
                if (clsA.uri != clsB.uri)
                {
                    let weight = clsA.length;
                    if (weight > MIN_WEIGHT)
                    {
                        if (edges.has(clsA.uri))
                        {
                            let source = edges.get(clsA.uri);
                            if (source.has(clsB.uri))
                            {
                                source.set(clsB.uri, source.get(clsB.uri)+weight); //TODO weight
                            }
                            else
                            {
                                source.set(clsB.uri, weight);
                            }
                        }
                        else
                        {
                            let target = new Map();
                            target.set(clsB.uri, weight);
                            edges.set(clsA.uri, target);
                        }
                    }
                }
            }
        }
    }
    return edges;
}

function getClasses(j) {
    let groups = j.groups;
    let classes = new Set();
    for (let group of groups)
    {
        if (group.classes === undefined) continue;
        for (let cls of group.classes)
        {
            classes.add(cls.uri);
        }
    }
    return Array.from(classes).map(e => {return {id: e, isSelected: false}});
}


document.addEventListener("DOMContentLoaded", () => {

    fetch("output.json").then(response => {
    response.json().then(responseJson => {
        
        let graph = removeIsolatedNodes(createGraphObject(responseJson));
        let edgeMap = getEdges(responseJson);

        // get svg attributes
        let svg = d3.select("svg");
        let width = +svg.attr("width");
        let height = +svg.attr("height");

        let simulation = buildForces(svg, width, height);
        let color = d3.scaleOrdinal(d3.schemeCategory20);
        let link = buildLinks(svg, graph);

        let node = svg.append("g")
            .attr("class", d => {
                if (d === undefined) return "";
                return "nodes" + d.isSelected ? " selected" : "";
            })
            .selectAll("circle")
            .data(graph.nodes).enter()
                .append("circle")
                .attr("r", 5)
                .attr("fill", function(d) { return color(d.group); })
                .call(d3.drag()
                    .on("start", d => dragstarted(d, simulation))
                    .on("drag", d => dragged(d, simulation))
                    .on("end", d => dragended(d, simulation)))
                .on("click", el => onNodeSelected(el, graph, responseJson.groups, edgeMap, node));

        node.append("title")
            .text(function(d) { return d.id; });

        simulation
            .nodes(graph.nodes)
            .on("tick", () => ticked(link, node));

        simulation.force("link")
            .links(graph.links);

        updateLarges(responseJson.largestClone.classes);
        document.querySelector("#cloned-percentage").textContent = responseJson.percentage + "%";
        
        });
    });

    d3.select("#statistics-tab").on("click", () => {
        d3.select("#statistics").classed("hidden", false);
        d3.select("#graph").classed("hidden", true);
        d3.select("#details").classed("hidden", true);
    })

    d3.select("#clone-tab").on("click", () => {
        d3.select("#statistics").classed("hidden", true);
        d3.select("#graph").classed("hidden", false);
        d3.select("#details").classed("hidden", false);
    })

});