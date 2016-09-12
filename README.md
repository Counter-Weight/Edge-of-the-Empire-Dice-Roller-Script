# Edge of the Empire Dice Roller Script
A macOS command-line script written in Swift 3 which rolls the unconventional dice of Fantasy Flight's Star Wars tabletop role-playing game [*Star Wars: Edge of the Empire*](https://www.fantasyflightgames.com/en/products/star-wars-edge-of-the-empire/).

## Running the script
1.  Download the `Edge of the Empire Diceroll` file.
2.  Run the script in Terminal or another macOS command-line by running the file as a command:
    -   `~/Path/To/File <dice arguments>`
    -   I went a step further for ease of use and added the command as an [alias in my bash profile](https://www.moncefbelyamani.com/create-aliases-in-bash-profile-to-assign-shortcuts-for-common-terminal-commands/), allowing me to run the command as easily as this:
        -   `roll <dice arguments>`
    -   The command is run with this format: `roll 2f 4p`, where each "number-letter" combo is the number of dice of each type to roll. For example, if you want to roll 2 Ability dice and 1 Proficiency die you would use `roll 2a 1p`. (When only 1 die of a type is needed, you can remove the "1": `roll 2a p`).

## Building
1.  Download or copy the contents of the `Edge of the Empire Diceroll.swift` file.
	-	You can simply run the source file without building a release version if you wish:
		-	`swift <path/to/file>`
2.  Build it either with [Terminal](https://realm.io/news/swift-for-CLI/ "click "read more""):
    -   `swiftc <path-to-file> -o <executable name>` This will put the built file in the directory (folder) at which you ran the command (default is your home folder).

	or with Xcode:	
	1.	Create a Command-Line project which has the contents of the `Edge of the Empire Diceroll.swift` file as it's code.
	2.	Build the project.	
	3.	Run the file under "Products" in Terminal.
3.  Then run the file. (see the "Running" section)
