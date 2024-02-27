##
# R script to parse the overall RepeatitionMaze material
# Create random lists, documentation and json file to be used in jsPsych
# !!! Be careful !!!
# If you run this script again a different randomization of the items across lists will be created 
# to check how it works copy this file and composed.csv in a new folder and rum me on R
## 

library(jsonlite)

#  create empty output files

readMeMD = "README.md"
cat('', file=readMeMD, append=F)
allitemsMD =  "allitems.md"
cat('', file=allitemsMD, append=F)

# read the hand-composed material

d = read.csv('composed.csv', header=F)

cat('# Items and Lists for RepeatitionMaze Experiment', file = readMeMD, append=T)
cat('The file *composed.csv* contains ...', file = readMeMD, append=T)

colnames(d) = c('item','cond','sentence','wp','word','nl','distgramm','distword','distpseudo','disnw')

cat("---\ntitle: Maze Task Material\n...\n", file=allitemsMD, fill=T, append=F)
headerMD = "   |      |   |   |   |   |   |   |   |\n:-:|-----:|:--|:--|:--|:--|:--|:--|:--|"
d$item = factor(d$item)
d$cond= factor(d$cond)
out = data.frame()
for (i in levels(d$item)) {
   for (c in levels(d$cond)) {
      tmp = unique(subset(d, item==i & cond==c, select=c('item','cond','sentence')))
      tmp$gramm = paste(d$distgramm[d$item==i & d$cond==c], sep=' ', collapse =' ')
      tmp$word = paste(d$distword[d$item==i & d$cond==c], sep=' ', collapse =' ')
      tmp$pseudo = paste(d$distpseudo[d$item==i & d$cond==c], sep=' ', collapse =' ')
      tmp$nw = paste(d$disnw[d$item==i & d$cond==c], sep=' ', collapse =' ')
      out = rbind(out, tmp)
      cat(headerMD,file =allitemsMD, fill=T, append=T) 
      cat(sprintf('%s|**%s**|%s|', i, c, gsub(' ','|', tmp$sentence)), file=allitemsMD, fill=T, append=T)
      cat(sprintf('%s|*%s*|%s|', i, "D-gramm", gsub(' ','|', tmp$gramm)), file=allitemsMD, fill=T, append=T)
      cat(sprintf('%s|*%s*|%s|', i, "D-salad", gsub(' ','|', tmp$word)), file=allitemsMD, fill=T, append=T)
      cat(sprintf('%s|*%s*|%s|', i, "D-pseudo", gsub(' ','|', tmp$pseudo)), file=allitemsMD, fill=T, append=T)
      cat(sprintf('%s|*%s*|%s|', i, "D-nonwrd", gsub(' ','|', tmp$nw)), file=allitemsMD, fill=T, append=T)
      cat("", file=allitemsMD, fill=T, append=T)
   }
}

#dei 38 item li assegno a tre gruppi casuali da 12 e ne scarto 2 
gr = data.frame(item = sample(it), group=c(rep('G1',12),rep('G2',12),rep('G3',12), NA,NA))
it = levels(out$item)

#creo tre liste a quadrato latino

lists = data.frame(
	cond= rep(c('regular','semv', 'syntv'), 3), 
	group = c('G1','G2','G3', 'G2','G3','G1', 'G3','G1','G2'),
	list = c(rep('listA',3), rep('listB',3), rep('listC',3))  
	)
m = merge(lists,gr)
h = merge(out,m)

alllists = list()
tmp = list()
for (l in c('listA','listB','listC') ) {
	tt = subset(h, list==l, select =c(item, cond,sentence, gramm))
	colnames(tt)[3]='s1'
	colnames(tt)[4]='s2'
	tmp[[l]] =tt
}

alllists[['gramm']] = tmp

tmp = list()
for (l in c('listA','listB','listC') ) {
	tt = subset(h, list==l, select =c(item, cond,sentence, word))
	colnames(tt)[3]='s1'
	colnames(tt)[4]='s2'
	tmp[[l]] =tt
}

alllists[['word']] = tmp

tmp = list()
for (l in c('listA','listB','listC') ) {
	tt = subset(h, list==l, select =c(item, cond,sentence, pseudo))
	colnames(tt)[3]='s1'
	colnames(tt)[4]='s2'
	tmp[[l]] =tt
}

alllists[['pseudo']] = tmp

tmp = list()
for (l in c('listA','listB','listC') ) {
	tt = subset(h, list==l, select =c(item, cond,sentence, nw))
	colnames(tt)[3]='s1'
	colnames(tt)[4]='s2'
	tmp[[l]] =tt
}

alllists[['nw']] = tmp

cat(toJSON(alllists, pretty=TRUE), file='stimall.json')

