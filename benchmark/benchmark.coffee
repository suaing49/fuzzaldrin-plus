fs = require 'fs'
path = require 'path'

{filter, match, prepQuery} = require '../src/fuzzaldrin'

lines = fs.readFileSync(path.join(__dirname, 'data.txt'), 'utf8').trim().split('\n')

forceAllMatch = {maxInners:-1}
legacy = {legacy:true}
mitigation = {maxInners:Math.floor(0.2*lines.length)}

#warmup + compile
filter(lines, 'index', forceAllMatch)
filter(lines, 'index', legacy)


console.log("======")

startTime = Date.now()
results = filter(lines, 'index')
console.log("Filtering #{lines.length} entries for 'index' took #{Date.now() - startTime}ms for #{results.length} results (~10% of results are positive, mix exact & fuzzy)")

if results.length isnt 6168
  console.error("Results count changed! #{results.length} instead of 6168")
  process.exit(1)

startTime = Date.now()
results = filter(lines, 'index', legacy)
console.log("Filtering #{lines.length} entries for 'index' took #{Date.now() - startTime}ms for #{results.length} results (~10% of results are positive, Legacy method)")


console.log("======")

startTime = Date.now()
results = filter(lines, 'indx')
console.log("Filtering #{lines.length} entries for 'indx' took #{Date.now() - startTime}ms for #{results.length} results (~10% of results are positive, Fuzzy match)")

startTime = Date.now()
results = filter(lines, 'indx', legacy)
console.log("Filtering #{lines.length} entries for 'indx' took #{Date.now() - startTime}ms for #{results.length} results (~10% of results are positive, Fuzzy match, Legacy)")

console.log("======")

startTime = Date.now()
results = filter(lines, 'walkdr')
console.log("Filtering #{lines.length} entries for 'walkdr' took #{Date.now() - startTime}ms for #{results.length} results (~1% of results are positive, fuzzy)")

startTime = Date.now()
results = filter(lines, 'walkdr', legacy)
console.log("Filtering #{lines.length} entries for 'walkdr' took #{Date.now() - startTime}ms for #{results.length} results (~1% of results are positive, Legacy method)")


console.log("======")

startTime = Date.now()
results = filter(lines, 'node', forceAllMatch)
console.log("Filtering #{lines.length} entries for 'node' took #{Date.now() - startTime}ms for #{results.length} results (~98% of results are positive, mostly Exact match)")

startTime = Date.now()
results = filter(lines, 'node', legacy)
console.log("Filtering #{lines.length} entries for 'node' took #{Date.now() - startTime}ms for #{results.length} results (~98% of results are positive, mostly Exact match, Legacy method)")


console.log("======")

startTime = Date.now()
results = filter(lines, 'nm', forceAllMatch)
console.log("Filtering #{lines.length} entries for 'nm' took #{Date.now() - startTime}ms for #{results.length} results (~98% of results are positive, Acronym match)")

startTime = Date.now()
results = filter(lines, 'nm', forceAllMatch)
console.log("Filtering #{lines.length} entries for 'nm' took #{Date.now() - startTime}ms for #{results.length} results (~98% of results are positive, Acronym match, Legacy method)")


console.log("======")

startTime = Date.now()
results = filter(lines, 'nodemodules', forceAllMatch)
console.log("Filtering #{lines.length} entries for 'nodemodules' took #{Date.now() - startTime}ms for #{results.length} results (~98% positive + Fuzzy match, [Worst case scenario])")

startTime = Date.now()
results = filter(lines, 'nodemodules', mitigation)
console.log("Filtering #{lines.length} entries for 'nodemodules' took #{Date.now() - startTime}ms for #{results.length} results (~98% positive + Fuzzy match, [Mitigation])")

startTime = Date.now()
results = filter(lines, 'nodemodules', legacy)
console.log("Filtering #{lines.length} entries for 'nodemodules' took #{Date.now() - startTime}ms for #{results.length} results (Legacy)")

console.log("======")

startTime = Date.now()
results = filter(lines, 'ndem', forceAllMatch)
console.log("Filtering #{lines.length} entries for 'ndem' took #{Date.now() - startTime}ms for #{results.length} results (~98% positive + Fuzzy match, [Worst case but shorter srting])")

startTime = Date.now()
results = filter(lines, 'ndem', legacy)
console.log("Filtering #{lines.length} entries for 'ndem' took #{Date.now() - startTime}ms for #{results.length} results (Legacy)")


console.log("======")

startTime = Date.now()
query = 'index'
prepared = prepQuery(query)
match(line, query, prepared) for line in lines
console.log("Matching #{results.length} results for 'index' took #{Date.now() - startTime}ms (Prepare in advance)")

startTime = Date.now()
match(line, query) for line in lines
console.log("Matching #{results.length} results for 'index' took #{Date.now() - startTime}ms (cache)")
# replace by `prepQuery ?= scorer.prepQuery(query)`to test without cache.
