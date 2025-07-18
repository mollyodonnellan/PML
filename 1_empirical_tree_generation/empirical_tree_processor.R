#Load in libraries
library(ape)
library(ggplot2)
library(geiger)
library(ggtree)

#Force a headless friendly bitmat device for the session (due to "unable to start device png" error)
options(bitmapType = "cairo")

#Adjust path to modified.write.tree2.R, a script that adjusts how ape handles treefiles
source("2_simulation_scripts/modified.write.tree2.R")
assignInNamespace(".write.tree2", .write.tree2, "ape")

#Adjust the paths to ML species trees for each dataset.

#Empirical species tree 1 (Fong et al.):

fong_tree <- read.tree("simulations/empirical/fong/1/inferenceEmpirical.treefile")
fong_tree <- root(fong_tree, outgroup = "Danio")
p <- ggtree(fong_tree) + theme_tree2() + geom_tiplab()
ggsave(p, file="simulations/empirical/fong/1/fong_tree_check_root.png")

#Check the tree rooted correctly. Then transform to ultrametric and rescale to correct #number of generations

fong_tree_um <- chronos(fong_tree)
class(fong_tree_um) <-"phylo"
fong_scale <- 435000000/10
fong_tree_um <- rescale(fong_tree_um, model = "depth", fong_scale)
q <- ggtree(fong_tree_um) + theme_tree2() + geom_tiplab()
ggsave(q, file="simulations/empirical/fong/1/fong_tree_um.png")

#Check the tree is correct. Then replace labels with numbers as in regular SimPhy #simulations and strip off the node labels (if any). Write out the tree and seeds for #subsequent dataset parameter simulations.

fong_tree_um$tip.label <- as.character(1:length(fong_tree_um$tip.label))
fong_tree_um$node.label <- NULL
write.tree(fong_tree_um, "simulations/empirical/fong/1/s_tree.trees", digits=8)
write(c(20001,10000),"simulations/empirical/fong/generate_params.txt")

#Empirical species tree 2 (Wickett et al.):

wickett_tree <- read.tree("simulations/empirical/wickett/1/inferenceEmpirical.treefile")
wickett_tree <- root(wickett_tree, outgroup = "Pyramimonas_parkeae")
r <- ggtree(wickett_tree) + theme_tree2() + geom_tiplab()
ggsave(r, file="simulations/empirical/wickett/1/wickett_tree_check_root.png")

wickett_tree_um <- chronos(wickett_tree)
class(wickett_tree_um) <-"phylo"
wickett_scale <- 1200000000/5
wickett_tree_um <- rescale(wickett_tree_um, model = "depth", wickett_scale)
wickett_tree_um$tip.label <- as.character(1:length(wickett_tree_um$tip.label))
wickett_tree_um$node.label <- NULL
s <-ggtree(wickett_tree_um) + theme_tree2()
ggsave (s, file="simulations/empirical/wickett/1/wickett_tree_um.png")
write.tree(wickett_tree_um, "simulations/empirical/wickett/1/s_tree.trees", digits=8)
write(c(20002,100000),"simulations/empirical/wickett/generate_params.txt")

#Empirical species tree 4 (Liu et al.):

liu_tree <- read.tree("simulations/empirical/liu/1/inferenceEmpirical.treefile")
liu_tree <- root(liu_tree, outgroup = "danio_rer")
u <- ggtree(liu_tree) + theme_tree2() + geom_tiplab()
ggsave(u, file="simulations/empirical/liu/1/liu_tree_check_root.png")
liu_tree_um <- chronos(liu_tree)
class(liu_tree_um) <-"phylo"
liu_scale <- 435000000/10
liu_tree_um <- rescale(liu_tree_um, model = "depth", liu_scale)
liu_tree_um$tip.label <- as.character(1:length(liu_tree_um$tip.label))
liu_tree_um$node.label <- NULL
v <- ggtree(liu_tree_um) + theme_tree2()
ggsave (v, file="simulations/empirical/liu/1/liu_tree_um.png")
write.tree(liu_tree_um, "simulations/empirical/liu/1/s_tree.trees", digits=8)
write(c(20004,10000),"simulations/empirical/liu/generate_params.txt")


