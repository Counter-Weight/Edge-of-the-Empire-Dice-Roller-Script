# Edge of the Empire Dice Roller Script
A macOS command-line script which rolls the unconventional dice of Fantasy Flight's Star Wars tabletop role-playing game [*Star Wars: Edge of the Empire*](https://www.fantasyflightgames.com/en/products/star-wars-edge-of-the-empire/) written in Swift

## Running the script for yourself
1. Download or copy the `Edge of the Empire Diceroll.swift` file.
2. Make the file executable via this command
	- `$ chmod -v u+x <file path>`
	- The `-v` portion turns on more expressive output, and the `u+x` portion gives you (`u`) executable (`x`) access
3. Run the script in Terminal or another macOS command-line by running the file as a command:
	- `$ ~/Path/To/File.swift <dice arguments>`
	- I went a step further for ease of use and added the command as an [alias in my bash profile](https://www.moncefbelyamani.com/create-aliases-in-bash-profile-to-assign-shortcuts-for-common-terminal-commands/), allowing me to run the command as easily as this:
		- `$ roll <dice arguments>`
	- The command is run with this format: `$ roll 2f 4p` where each "number-letter" is the number of dice of each type to roll. If you want to roll 2 Ability dice and 1 Proficiency die you would use `$ roll 2a 1p`. (When only 1 die of a type is needed, you can remove the "1": `$ roll 2a p`)
