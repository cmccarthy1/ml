\l ml.q
.ml.loadfile`:clust/q/init.q
.ml.loadfile`:util/init.q

\S 10

d1:(til 5;3 2 5 1 4)
d2:(2#"F";",")0:`:clust/tests/data/sample1.csv
tree:.ml.clust.kd.newtree[d1;1]
tree2:.ml.clust.kd.newtree[d2;2]
info:.ml.clust.i.apinit[d1;`e2dist;max]

// k-d Tree using C 

.ml.clust.i.dists[d1;`e2dist;4 2;1 2 3]~9 13 2
.ml.clust.i.dists[d1;`e2dist;8 2;til 5]~65 49 45 26 20
.ml.clust.i.closest[d1;`e2dist;1 2;til 5]~`point`distance!(1;0)
.ml.clust.i.closest[d2;`e2dist;3 6;reverse til 5][`point]~2
.ml.clust.kd.newtree[d1;2][`left]~010b
.ml.clust.kd.newtree[d1;2][`leaf]~011b
.ml.clust.kd.newtree[d1;2][`midval]~2 0n 0n
.ml.clust.kd.newtree[d1;2][`parent]~0N 0 0
.ml.clust.kd.newtree[d1;2][`idxs]~(0#0;0 1;2 3 4)
.ml.clust.kd.newtree[d1;2][`axis]~0 0N 0N
.ml.clust.kd.newtree[d2;3][`left]~010b
.ml.clust.kd.newtree[d2;3][`leaf]~011b
.ml.clust.kd.newtree[d2;3][`idxs]~(0#0;til 5;5 6 7 8 9)
.ml.clust.kd.newtree[d2;3][`parent]~0N 0 0
.ml.clust.kd.newtree[d2;3][`idxs]~(0#0;til 5;5+til 5)
.ml.clust.kd.nn[tree;d1;`edist;0;d2[;2]][`closestPoint]~2
.ml.clust.kd.nn[tree;d1;`mdist;1 2 3 4;d1[;1]][`closestPoint`closestDist]~(0;2f)
.ml.clust.kd.nn[tree;d1;`mdist;1;7 9f][`closestPoint`closestDist]~(4;8f)
.ml.clust.kd.nn[tree2;d2;`edist;1 2 3;d1[;1]][`closestPoint]~0
.ml.clust.kd.nn[tree2;d2;`edist;1 5 2;d1[;3]][`closestPoint]~3
.ml.clust.kd.nn[tree2;d2;`edist;0;d2[;2]][`closestPoint`closestDist]~(2;0f)
.ml.clust.kd.findleaf[tree;d1[;1];tree 0]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;0b;3;1;0#0;0N;0n;enlist 1))
.ml.clust.kd.findleaf[tree;d2[;4];tree 2]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;1b;2;1;0#0;0N;0n;enlist 0))
.ml.clust.kd.findleaf[tree2;d2[;1];tree2 1]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;0b;3;1;0#0;0N;0n;1 3 4))
.ml.clust.kd.findleaf[tree2;d1[;0];tree2 2]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;1b;2;1;0#0;0N;0n;0 2))

// k-d Tree using q
.ml.clust.kd.qC[1b];
.ml.clust.kd.nn[tree;d1;`edist;0;d2[;2]][`closestPoint]~2
.ml.clust.kd.nn[tree;d1;`mdist;1 2 3 4;d1[;1]][`closestPoint`closestDist]~(0;2)
.ml.clust.kd.nn[tree;d1;`mdist;1;7 9f][`closestPoint`closestDist]~(4;8f)
.ml.clust.kd.nn[tree2;d2;`edist;1 2 3;d1[;1]][`closestPoint]~0
.ml.clust.kd.nn[tree2;d2;`edist;1 5 2;d1[;3]][`closestPoint]~3
.ml.clust.kd.nn[tree2;d2;`edist;0;d2[;2]][`closestPoint`closestDist]~(2;0f)
.ml.clust.kd.findleaf[tree;d1[;1];tree 0]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;0b;3;1;0#0;0N;0n;enlist 1))
.ml.clust.kd.findleaf[tree;d2[;4];tree 2]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;1b;2;1;0#0;0N;0n;enlist 0))
.ml.clust.kd.findleaf[tree2;d2[;1];tree2 1]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;0b;3;1;0#0;0N;0n;1 3 4))
.ml.clust.kd.findleaf[tree2;d1[;0];tree2 2]~(`leaf`left`self`parent`children`axis`midval`idxs!(1b;1b;2;1;0#0;0N;0n;0 2))

// K-Means

.ml.clust.i.getclust[d2;`e2dist;flip d2[;1 2]]~1 0 1 0 0 0 0 0 0 0
.ml.clust.i.getclust[d2;`e2dist;flip d2[;1 2 3]]~1 0 1 2 2 2 2 2 2 2
.ml.clust.i.getclust[d1;`e2dist;flip d1[;2 3]]~0 1 0 1 0
.ml.clust.i.getclust[d1;`edist;flip d1[;3 4]]~0 0 1 0 1

// DBSCAN

.ml.clust.i.nbhood["f"$d1;`edist;10;4]~0 1 2 3
.ml.clust.i.nbhood[d2;`e2dist;0.1;1]~ 0 3
.ml.clust.i.nbhood[d2;`edist;0.3;3]~0 1

// Affinity Propagation

.ml.clust.i.apinit[d2;`e2dist;med][`matches]~0
.ml.clust.i.apinit[d1;`e2dist;min][`s]~(0 2 8 13 17;2 0 10 5 13;8 10 0 17 5 ;13 5 17 0 10;17 13 5 10 0)
.ml.clust.i.apinit[d1;`e2dist;min][`a]~5 5#0f
.ml.clust.i.apinit[d1;`e2dist;max][`r]~5 5#0f
.ml.clust.i.apalgo[0.1;info][`exemplars]~0 1 2 2 0
.ml.clust.i.apalgo[0.1;info][`s]~(17 2 8 13 17;2 17 10 5 13;8 10 17 17 5;13 5 17 17 10;17 13 5 10 17)
.ml.clust.i.apalgo[0.1;info][`a]~"f"$(3.24 0 0 0 0;0 0 0 0 0;0 0 3.24 0 0;0 0 0 0 0;0 0 0 0 0)
.ml.clust.i.updr[0.2;info]~(0 -12 -7.2 -3.2 0;-12 3.2 -5.6 -9.6 -3.2;-7.2 -5.6 0 0 -9.6;-3.2 -9.6 3.2 0 -5.6;3.2  -3.2 -9.6 -5.6 0)
.ml.clust.i.updr[0.1;info]~(0 -13.5 -8.1 -3.6 0;-13.5 3.6 -6.3 -10.8 -3.6;-8.1 -6.3 0 0 -10.8;-3.6 -10.8 3.6 0 -6.3;3.6 -3.6 -10.8 -6.3 0)
.ml.clust.i.upda[0.5;info]~5 5#0f
.ml.clust.i.upda[0.9;info]~5 5#0f
