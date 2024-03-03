# Repetition Maze

Repository for Repetition Maze Experiment both born open-source (jsPsych on github) and born open-data (datapipe, osf).

##  Aim

todo

## Material

todo

[Exp1 material](https://francesco-vespignani.github.io/RepetitionMaze/exp1_material/allitems.html)

##  Test the experiment

[https://francesco-vespignani.github.io/RepetitionMaze/run/?id=john&distr=pseudo&list=listB&casual=false&nrep=3&n=2](https://francesco-vespignani.github.io/RepetitionMaze/run/?id=john&distr=pseudo&list=listB&casual=false&nrep=3&n=2)

Available url parameters (if missing default will be used):

- id, id of the run. Default is null. **If there is a stored data for a given id no data will be saved in osf, after opening the above link change john with something else to save data.** If null or absent a random 10 char id will be generated. If id is provided the "url" string is added before the id in the osf filenames. This can allow to link the data with real person and anagraphic data;

- dist, type of distracters. Available values are nw (nonwords), pseudo (pseudowords), word (word salad), gramm (grammatical sentences). Default is nw.

- list, one of three lists. Available values ara listA listB listC, default listA;

- casual, if items are presented randomly. Available values are true and false. Default is true.

- nrep, number of maze repetitions for each item. Available values are positive integers. Default is 5.

- n, number experimental items to make the experiment shoprter for testing. Available values are positive integers below 36. Default is null (all 36 items)

Data will be automatically saved in this ofs component:

[https://osf.io/vh864/?view_only=](https://osf.io/vh864/?view_only=)

For each run two files are saved, one with practice data  and one with experiment data, this allow to check how many subjects started the experiment without finishing it. No data is saved until the end of practice/experiment and data is not overwritten (if run with the same id).

##  Participate

If you are and Italian motherlanguage speaker between 18 and 30 years old and would like to partecipate to the real experiment follow one of these links (from the easier to more difficult), changing list and id in the browser after opening the link belows:

[https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=nw&list=listA&casual=true](https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=nw&list=listA&casual=true)

[https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=pseudo&list=listA&casual=true](https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=pseudo&list=listA&casual=true)

[https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=word&list=listA&casual=true](https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=word&list=listA&casual=true)

[https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=gramm&list=listA&casual=true](https://francesco-vespignani.github.io/RepetitionMaze/run/?id=CHANGEME&distr=gramm&list=listA&casual=true)




