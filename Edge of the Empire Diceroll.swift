import Darwin // for arc4random_uniform

enum Symbol { // state values for dice faces
	// case blank // removed to simplify calculations
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
	let num = arc4random_uniform(12) + 1

	switch num {
	case 1...6:
		return [.dark]
	case 7:
		return [.dark]
	case 8, 9:
		return [.light]
	case 10...12:
		return [.light, .light]
	default:
		return []
	}
}

func challengeDie() -> [Symbol] {
	let num = arc4random_uniform(12) + 1

	switch num {
	case 1:
		return []
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
		return []
	}
}

func proficiencyDie() -> [Symbol] {
	let num = arc4random_uniform(12) + 1

	switch num {
	case 1:
		return []
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
		return []
	}
}

func difficultyDie() -> [Symbol] {
	let num = arc4random_uniform(8) + 1

	switch num {
	case 1:
		return []
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
		return []
	}
}

func abilityDie() -> [Symbol] {
	let num = arc4random_uniform(8) + 1

	switch num {
	case 1:
		return []
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
		return []
	}
}

func setBackDie() -> [Symbol] {
	let num = arc4random_uniform(6) + 1

	switch num {
	case 1, 2:
		return []
	case 3, 4:
		return [.failure]
	case 5, 6:
		return [.threat]
	default:
		return []
	}
}

func boostDie() -> [Symbol] {
	let num = arc4random_uniform(6) + 1

	switch num {
	case 1, 2:
		return []
	case 3:
		return [.advantage, .advantage]
	case 4:
		return [.advantage]
	case 5:
		return [.advantage, .success]
	case 6:
		return [.success]
	default:
		return []
	}
}
/* End Of The Die Types */

// determines which die to roll
func rollDice(numberOfDice number: Int, ofType type: Character) -> [Symbol] {
	// stores the function to roll dice
	let typeFunction : () -> [Symbol]

	// determine type of dice and set the `typeFunction` appropriately
	switch type {
	case "f":
		typeFunction = forceDie
	case "c":
		typeFunction = challengeDie
	case "p":
		typeFunction = proficiencyDie
	case "d":
		typeFunction = difficultyDie
	case "a":
		typeFunction = abilityDie
	case "s":
		typeFunction = setBackDie
	case "b":
		typeFunction = boostDie
	default:
		print("`\(type)`, is not a valid dice type, the final character of an argument must be the type of dice")
		return []
	}

	// roll dice
	var result = [Symbol]()
	for _ in 0..<number {
		result += typeFunction()
	}
	return result
}

// outputs the results of a roll
func output() {
	// continue unlesss empty: no die were rolled, or only blanks were rolled
	guard !roll.isEmpty else {
		print("Empty/blank roll")
		print("FAILURE!")
		return
	}

	var successes = 0,
		failures = 0,
		advantages = 0,
		threats = 0,
		light = 0,
		dark = 0,
		triumphs = 0,
		despairs = 0

	for dieFace in roll {
		switch dieFace {
		case .success:
			successes += 1
		case .failure:
			failures += 1
		case .advantage:
			advantages += 1
		case .threat:
			threats += 1
		case .light:
			light += 1
		case .dark:
			dark += 1
		case .triumph:
			triumphs += 1
		case .despair:
			despairs += 1
		}
	}

	if successes + triumphs - despairs - threats > 0 {
		print("SUCCESS!")
	} else {
		print("FAILURE!")
	}
	// Success/Failure
	if successes > 0 {
		print("\(successes) Success" + (successes > 1 ? "es" : ""))
	}
	if failures > 0 {
		print("\(failures) Failure" + (failures > 1 ? "s" : ""))
	}
	// Advantage/Threat
	if advantages > 0 {
		print("\(advantages) Advantage" + (advantages > 1 ? "s" : ""))
	}
	if threats > 0 {
		print("\(threats) Threat" + (threats > 1 ? "s" : ""))
	}
	// Triumph/Despair
	if triumphs > 0 {
		print("\(triumphs) Triumph" + (triumphs > 1 ? "s" : ""))
	}
	if despairs > 0 {
		print("\(despairs) Despair" + (despairs > 1 ? "s" : ""))
	}
	// Light/Dark
	if light > 0 {
		print("\(light) Light Side" + (light > 1 ? "s" : ""))
	}
	if dark > 0 {
		print("\(dark) Dark Side" + (dark > 1 ? "s" : ""))
	}
}

var roll = [Symbol]()
// parses the command line argument for the number and type of dice to roll
for arg in CommandLine.arguments.dropFirst() { // second argument and onward, because the first argument seems to be the call to the file/command
	// should be the type of dice
	guard let diceType = arg.characters.last else {
		print("no dice-type was specified for `\(arg)`")
		continue
	}

	// dice should be the number of dice to roll. If not, then 
	let dice = Int(String(arg.characters.dropLast())) ?? 1
	roll += rollDice(numberOfDice: dice, ofType: diceType)
}

// count/calc each die face and output
output()
