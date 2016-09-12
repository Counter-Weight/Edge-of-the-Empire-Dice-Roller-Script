import Darwin // for arc4random_uniform

enum Symbol { // state values for dice faces
	case blank
	case success
	case failure
	case advantage
	case threat
	case triumph // critical_success
	case despair // critical_failure
	case light
	case dark
}

/* All The Die Types */
func forceDie() -> [Symbol] {
	switch arc4random_uniform(12) + 1 {
	case 1...6:
		return [.dark]
	case 7:
		return [.dark]
	case 8, 9:
		return [.light]
	case 10...12:
		return [.light, .light]
	default:
		return [.blank]
	}
}

func challengeDie() -> [Symbol] {
	switch arc4random_uniform(12) + 1 {
	case 1:
		return [.blank]
	case 2, 3:
		return [.failure]
	case 4, 5:
		return [.failure, .failure]
	case 6, 7:
		return [.threat]
	case 8, 9:
		return [.threat, .failure]
	case 10, 11:
		return [.threat, .threat]
	case 12:
		return [.despair]
	default:
		return [.blank]
	}
}

func proficiencyDie() -> [Symbol] {
	switch arc4random_uniform(12) + 1 {
	case 1:
		return [.blank]
	case 2, 3:
		return [.success]
	case 4, 5:
		return [.success, .success]
	case 6:
		return [.advantage]
	case 7...9:
		return [.advantage, .success]
	case 10, 11:
		return [.advantage, .advantage]
	case 12:
		return [.triumph]
	default:
		return [.blank]
	}
}

func difficultyDie() -> [Symbol] {
	switch arc4random_uniform(8) + 1 {
	case 1:
		return [.blank]
	case 2:
		return [.failure]
	case 3:
		return [.failure, .failure]
	case 4...6:
		return [.threat]
	case 7:
		return [.threat, .threat]
	case 8:
		return [.threat, .failure]
	default:
		return [.blank]
	}
}

func abilityDie() -> [Symbol] {
	switch arc4random_uniform(8) + 1 {
	case 1:
		return [.blank]
	case 2, 3:
		return [.success]
	case 4:
		return [.success, .success]
	case 5, 6:
		return [.advantage]
	case 7:
		return [.success, .advantage]
	case 8:
		return [.advantage, .advantage]
	default:
		return [.blank]
	}
}

func setBackDie() -> [Symbol] {
	switch arc4random_uniform(6) + 1 {
	case 1, 2:
		return [.blank]
	case 3, 4:
		return [.failure]
	case 5, 6:
		return [.threat]
	default:
		return [.blank]
	}
}

func boostDie() -> [Symbol] {
	switch arc4random_uniform(6) + 1 {
	case 1, 2:
		return [.blank]
	case 3:
		return [.advantage, .advantage]
	case 4:
		return [.advantage]
	case 5:
		return [.advantage, .success]
	case 6:
		return [.success]
	default:
		return [.blank]
	}
}
/* End Of The Die Types */

// determines which die to roll
func rollDie(_ type: Character) -> [Symbol] {
	switch type {
	case "f":
		return forceDie()
	case "c":
		return challengeDie()
	case "p":
		return proficiencyDie()
	case "d":
		return difficultyDie()
	case "a":
		return abilityDie()
	case "s":
		return setBackDie()
	case "b":
		return boostDie()
	default:
		return [.blank]
	}
}

// outputs the results of a roll
func output() {
	// counts occurrences by counting the elements in a new array formed only of the matching items in `roll`
	let successes = roll.filter{ $0 == .success }.count - roll.filter{ $0 == .failure }.count
	let advantages = roll.filter{ $0 == .advantage }.count - roll.filter{ $0 == .threat }.count
	let light = roll.filter{ $0 == .light }.count
	let dark = roll.filter{ $0 == .dark }.count
	let triumphs = roll.filter{ $0 == .triumph }.count
	let despairs = roll.filter{ $0 == .despair }.count

	if successes | advantages | light | dark | triumphs | despairs == 0 {
		// checks if any of the counts aren't 0 by checking if their combined binary number is anything but 0b0
		print("Blank/neutral roll")
	} else {
		// Success/Failure
		if successes > 0 {
			print("\(successes) \tSuccess\((successes > 1) ? "es":"")")
		} else if successes < 0 {
			print("\(abs(successes)) \tFailure\((abs(successes) > 1) ? "s":"")")
		}
		// Advantage/Threat
		if advantages > 0 {
			print("\(advantages) \tAdvantage\((advantages > 1) ? "s":"")")
		} else if advantages < 0 {
			print("\(abs(advantages)) \tThreat\((abs(advantages) > 1) ? "s":"")")
		}
		// Triumph/Despair
		if triumphs > 0 {
			print("\(triumphs) \tTriumph\((triumphs > 1) ? "s":"")")
		}
		if despairs > 0 {
			print("\(despairs) \tDespair\((despairs > 1) ? "s":"")")
		}
		// Light/Dark
		if light > 0 {
			print("\(light) \tLight Side\(((light) > 1) ? "s":"")")
		}
		if dark > 0 {
			print("\(dark) \tDark Side\(((dark) > 1) ? "s":"")")
		}
	}
}

var roll: [Symbol] = []
//parses the command line argument for the number and type of dice to roll
for arg in Process.arguments.dropFirst() { // second argument and onward, because the first argument seems to be the call to the file/command
	let indexOfType = arg.index(before: arg.endIndex) // assuming the input was given as: dice number, dice type ("2a"). the last character should be the dice type and all previous characters form the number of dice
	let character = arg[indexOfType] // should be dice type

	switch character {
	case "f", "c", "p", "d", "a", "s", "b": // a valid type of dice
		if let dice = Int(arg[arg.startIndex..<indexOfType]) { // should be the number of dice of a type to roll
			for _ in 0..<dice {
				roll += rollDie(character)
			}
		} else {
			roll += rollDie(character) // if no number was provided, roll 1 die
		}
	default: // not a valid type of dice
		print("`\(character)` is not a valid dice type, no character past the type of dice is allowed")
		break
	}
}

// count/calc each die face and output
output()
