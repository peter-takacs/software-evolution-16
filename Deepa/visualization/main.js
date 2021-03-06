var MIN_WEIGHT = 6;

            fetch('output.json',{mode:'no-cors'}).then(response => {
                response.json().then(j => {
                    
                    let graph = removeIsolatedNodes(createGraphObject(j));
                    let edgeMap = getEdges(j);

                    let svg = d3.select("svg"),
                        width = +svg.attr("width"),
                        height = +svg.attr("height");

                    let color = d3.scaleOrdinal(d3.schemeCategory20);

                    let manyBodyForce = d3.forceManyBody();
                    manyBodyForce.strength(_ => -10);

                    let centerForce = d3.forceCenter(width / 2, height / 2);

                    let simulation = d3.forceSimulation()
                        .force("link", d3.forceLink().id(function(d) { return d.id; }))
                        .force("charge", manyBodyForce)
                        .force("center", centerForce);

                    let link = svg.append("g")
                        .attr("class", "links")
                        .selectAll("line")
                        .data(graph.links)
                        .enter().append("line")
                        .attr("stroke-width", function(d) { return Math.sqrt(d.value); });

                    let node = svg.append("g")
                        .attr("class", d => {
                            if (d === undefined) return "";
                            return "nodes" + d.isSelected ? " selected" : "";
                        })
                        .selectAll("circle")
                        .data(graph.nodes)
                        .enter().append("circle")
                        .attr("r", 5)
                        .attr("fill", function(d) { return color(d.group); })
                        .call(d3.drag()
                            .on("start", d => dragstarted(d, simulation))
                            .on("drag", d => dragged(d, simulation))
                            .on("end", d => dragended(d, simulation)))
                        .on("click", function(el) {
                            for (let n of graph.nodes)
                            {
                                n.isSelected = false;
                                n.isSecondary = false;
                            }

                            el.isSelected = true;

                            document.querySelector(".selected-class").textContent = el.id.split("/").pop();

                            updateList(getClones(el.id, j.groups));

                            let nei = graph.nodes.filter(n => Array.from(edgeMap.get(el.id)).map(i => i[0]).includes(n.id));
                            for (let n of nei)
                            {
                                n.isSecondary = true;
                            }


                            node.data(graph.nodes)
                                .classed("nodes", true)
                                .classed("selected", d=>d.isSelected)
                                .classed("secondary", d=>d.isSecondary);
                        });

                    node.append("title")
                        .text(function(d) { return d.id; });

                    simulation
                        .nodes(graph.nodes)
                        .on("tick", () => ticked(link, node));

                    simulation.force("link")
                        .links(graph.links);
                })
            });

            function getClones(cls, groups) 
            {
                let result = [];
                for (let group of groups)
                {
                    if (group === undefined || group.classes == undefined) continue;
                    if (group.classes.some(e => e.uri == cls && e.end - e.begin > MIN_WEIGHT))
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
                    .text(d => d.source.uri.split("/").pop() + " " + d.source.begin + "-" + d.source.end);
                  entered.selectAll("div")
                    .data(d => d.target)
                    .enter().append("div")
                        .classed("target", true)                        
                        .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end);

                divs.classed("source", true)
                    .text(d => d.source.uri.split("/").pop() + " " + d.source.begin + "-" + d.source.end)
                        .selectAll("div")
                            .data(d => d.target)
                            .enter().append("div")
                                .classed("target", true)                        
                                .text(d => d.uri.split("/").pop() + " " + d.begin + "-" + d.end);   
                    
                divs.exit().remove();
                
                
            }


            function ticked(link, node)
            {
                const width = 960;
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
                    if (group.classes === undefined) continue;
                    for (let clsA of group.classes)
                    {
                        if (group.classes === undefined) continue;
                        for (let clsB of group.classes)
                        {
                            if (clsA.uri != clsB.uri)
                            {
                                if (clsA.uri == undefined || clsB.uri == undefined) continue;
                                let weight = clsA.end-clsA.begin;
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