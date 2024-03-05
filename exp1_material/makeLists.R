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

#  create readme file

cat('# Items and Lists for RepeatitionMaze Experiment\n\n', file = readMeMD, append=T)
cat('The file *composed.csv* contains ... \n', file = readMeMD, append=T)
cat('*allitems* contains all items for easy visualization\n', file = readMeMD, append=T)
cat('*material.json* contains all lists for jsPsych\n', file = readMeMD, append=T)


# read the hand-composed material

d = read.csv('composed.csv', header=F)

# create pretty item lists


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


# use pandoc (in linux)

system('pandoc -s -o ./allitems.pdf --from=markdown+pipe_tables ./allitems.md')
system('pandoc -s -o ./allitems.html --from=markdown+pipe_tables ./allitems.md')

# create 3 groups of 12 exp items and 3 practice items (specifiyed) 

it = levels(out$item)
pract = c("139", "130", "131")
exp = it[!(it %in% pract)]

# randomly assign items to three groups, used set.seed for reproducibility

set.seed(99353)

gr_pract = data.frame(item = sample(pract), group=c(rep('G1',1),rep('G2',1),rep('G3',1)))
gr_exp = data.frame(item = sample(exp), group=c(rep('G1',12),rep('G2',12),rep('G3',12)))

# create 3 lists in a square latin design and save item's assignment in  a csv file

lists = data.frame(
	cond= rep(c('regular','semv', 'syntv'), 3), 
	group = c('G1','G2','G3', 'G2','G3','G1', 'G3','G1','G2'),
	list = c(rep('listA',3), rep('listB',3), rep('listC',3))  
	)
m_exp = merge(lists,gr_exp)
m_pract = merge(lists,gr_pract)
h_exp = merge(out,m_exp)
h_pract = merge(out,m_pract)

s_exp = subset(h_exp, select=c(item,group,list,cond))
write.csv(s_exp[order(s_exp$group, s_exp$item),], file='exp_lists.csv', row.names=F)
s_pract = subset(h_pract, select=c(item,group,list,cond))
write.csv(s_pract[order(s_pract$group, s_pract$item),], file='pract_lists.csv', row.names=F)

# create hierarchical structure with different lists as a function of 
# different distracters in the maze task


alllists = list()

for (cond in c('gramm', 'word','pseudo','nw')) { 
   tmp = list()
	for (l in c('listA','listB','listC') ) {
		expi =  h_exp[h_exp$list==l ,which(colnames(h_exp) %in% c('item','cond','sentence', cond))]
		colnames(expi)[3]='s1'
		colnames(expi)[4]='s2'
		practi =  h_pract[h_pract$list==l ,which(colnames(h_pract) %in% c('item','cond','sentence', cond))]
		colnames(practi)[3]='s1'
		colnames(practi)[4]='s2'
		tmp[[l]] = list('exp' = expi, 'pract' = practi )
	}
	alllists[[cond]] = tmp
}

cat(toJSON(alllists, pretty=TRUE), file='material.json', append=FALSE)

