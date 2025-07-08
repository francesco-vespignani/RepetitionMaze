# Repetion Maze Distractor Generator 

Repetition Maze Distractor Generator – User Guide
What this app does

The Repetition Maze Distractor Generator allows you to create structured experimental datasets for psycholinguistic tasks where participants must choose between a real target word and a non-word distractor. For each word in a sentence, the app generates multiple distractor versions using controlled randomization, ensuring that the distractors are not real words.

**Key Features**

*1. Sentence Input*

You can generate trials from custom or preloaded sentences:

Enter any sentence in the "Enter a sentence" field and click "Add Sentence" to include it in the dataset.

Use the "Importa frasi SAND" button to load a set of predefined Italian sentences.

Upload a .txt file containing multiple sentences (separated by commas) using the "Carica file" input, then click "Importa frasi da file".

Each sentence is split into individual words (targets), and a row is generated for each one.

*2. Distractor Generation*

For each target word, the app automatically creates three distinct distractor versions: dist1, dist2, and dist3.

The distractor generator:

Counts the number of vowels and consonants in the original word.

Randomly samples the same number of vowels and consonants from the alphabet.

Shuffles them to form a non-word distractor.

Preserves capitalization if the original word starts with a capital letter.

Rejects any distractor that matches a real word listed in the provided lexicon (phi), ensuring all distractors are fake words.

*3. Side Assignment*

Each target-distractor pair is assigned a left/right side randomly for each version:

side1, side2, and side3 determine whether the target appears on the left (1) or right (0).

You can preview which distractor version to view using the dropdown selector ("Choose distractor version").

*4. Trial Preview*

The main panel includes a "Trial Presentation" area that visually simulates what a participant would see:

The target and distractor are shown on the left or right side of a central fixation point.

Use the "← Left" and "Right →" buttons to scroll through trials.

*5. Dataset Management*

The app provides a dynamic and editable dataset table:

Each word from each sentence appears as a row, with its distractors and assigned sides.

You can edit values manually within the table.

Use the "Delete" button to remove all rows related to a specific sentence (by item number).

Use "Clear Dataset" to remove all data and start fresh.

*6. Download Results*

Once you are satisfied with the dataset, use the "Download Dataset" button to export your trials as a CSV file ready for use in experimental presentation software.

*7. Generation Info Panel*

Click "Info generation" to open an explanation panel describing:

How distractors are created and filtered.

How side assignment works for experimental layout purposes.

**Note**

The distractor generation logic filters out real words using a reference dictionary [Phoneitalia](https://github.com/stefanocoretta/phonItaliaR/blob/main/data/phonitalia.rda). However, due to the random nature of the letter combinations, manual review is always recommended before finalizing stimuli.


---

## 📦 How to Run

###  Locally in R studio downloading /app.R
### via [this link](https://pnslhg-giulia-calignano.shinyapps.io/repetitionmaze_distractorgenerator/)




