import Darwin.C.math // for arc4random_uniform

private var blanks = false // used only when the roll is completely blank
private var successes = 0
private var failures = 0
private var advantages = 0
private var threats = 0
private var triumphs = 0 // critical successes
private var despairs = 0 // critical failures
private var lights = 0
private var darks = 0

// arc4random_uniform gives a result from 0 to below the number given as an argument
// so to match dice values, a 1 must be added to the function's output
private let random: (UInt32) -> UInt32 = { arc4random_uniform($0) + 1 }

// =================== Begin - All The Die Types =================== //
private func forceDie(_ num: Int) {
	for _ in 0..<num {
		switch random(12) {
		case 1...6:
			darks += 1
		case 7:
			darks += 1
		case 8, 9:
			lights += 1
		case 10...12:
			lights += 2
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func challengeDie(_ num: Int) {
	for _ in 0..<num {
		switch random(12) {
		case 1:
			blanks = true
		case 2, 3:
			failures += 1
		case 4, 5:
			failures += 2
		case 6, 7:
			threats += 1
		case 8, 9:
			threats += 1; failures += 1
		case 10, 11:
			threats += 2
		case 12:
			despairs += 1
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func proficiencyDie(_ num: Int) {
	for _ in 0..<num {
		switch random(12) {
		case 1:
			blanks = true
		case 2, 3:
			successes += 1
		case 4, 5:
			successes += 2
		case 6:
			advantages += 1
		case 7...9:
			advantages += 1; successes += 1
		case 10, 11:
			advantages += 2
		case 12:
			triumphs += 1
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func difficultyDie(_ num: Int) {
	for _ in 0..<num {
		switch random(8) {
		case 1:
			blanks = true
		case 2:
			failures += 1
		case 3:
			failures += 2
		case 4...6:
			threats += 1
		case 7:
			threats += 2
		case 8:
			threats += 1; failures += 1
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func abilityDie(_ num: Int) {
	for _ in 0..<num {
		switch random(8) {
		case 1:
			blanks = true
		case 2, 3:
			successes += 1
		case 4:
			successes += 2
		case 5, 6:
			advantages += 1
		case 7:
			successes += 1; advantages += 1
		case 8:
			advantages += 2
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func setBackDie(_ num: Int) {
	for _ in 0..<num {
		switch random(6) {
		case 1, 2:
			blanks = true
		case 3, 4:
			failures += 1
		case 5, 6:
			threats += 1
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}

private func boostDie(_ num: Int) {
	for _ in 0..<num {
		switch random(6) {
		case 1, 2:
			blanks = true
		case 3:
			advantages += 2
		case 4:
			advantages += 1
		case 5:
			advantages += 1; successes += 1
		case 6:
			successes += 1
		default:
			print("Error: errant random number")
			exit(1)
		}
	}
}
// =================== End - All The Die Types =================== //

private func usage() {
	print("USAGE: <command> [Number][Type] [Number][Type] ...")
	print()
	print("\t" + "type: use only the first character of the die type's name")
	print("\t" + "e.g. `<command> 2b 3a` for 2 Boost dice and 3 Ability dice")
	print()
	print("INPUT:", CommandLine.arguments.dropFirst())

	exit(1)
}

// determines which die to roll
private func rollDice(number num: Int, ofType type: Character) {
	switch type {
	case "f":
		forceDie(num)
	case "c":
		challengeDie(num)
	case "p":
		proficiencyDie(num)
	case "d":
		difficultyDie(num)
	case "a":
		abilityDie(num)
	case "s":
		setBackDie(num)
	case "b":
		boostDie(num)
	default:
		print("`\(type)`, is not a valid dice type, the final character of an argument must be the type of dice")
		usage()
	}
}

private var notZeros: Bool { return successes > 0 || failures > 0 || advantages > 0 ||
	threats > 0 || triumphs > 0 || despairs > 0 || lights > 0 || darks > 0 }

// outputs the results of a roll
private func output() {
	if successes + triumphs - failures - despairs > 0 {
		print("===== SUCCESS! =====")
	} else {
		print("===== FAILURE! =====")
	}

	// continue unlesss no die were rolled or only blanks were rolled
	guard notZeros else {
		print("Only blanks were rolled")
		exit(0)
	}

	// Successes/Failures
	let total = successes - failures
	if total > 0 {
		print("\(total) Successes"/* + (successes > 1 ? "es" : "")*/)
	} else if total < 0 {
		print("\(-total) Failures"/* + (successes > 1 ? "s" : "")*/)
	}
	// Advantages/threats
	let total_2 = advantages - threats
	if total_2 > 0 {
		print("\(total_2) Advantages"/* + (advantages > 1 ? "s" : "")*/)
	} else if total_2 < 0 {
		print("\(-total_2) Threats"/* + (threats > 1 ? "s" : "")*/)
	}
	// Triumphs/Despair
	if triumphs > 0 {
		print("\(triumphs) Triumphs"/* + (triumphs > 1 ? "s" : "")*/)
	}
	if despairs > 0 {
		print("\(despairs) Despairs"/* + (despairs > 1 ? "s" : "")*/)
	}
	// Lights/Darks
	if lights > 0 {
		print("\(lights) Light Sides"/* + (lights > 1 ? "s" : "")*/)
	}
	if darks > 0 {
		print("\(darks) Dark Sides"/* + (darks > 1 ? "s" : "")*/)
	}
}

// parses the command line arguments for the number and type of dice to roll
for arg in CommandLine.arguments.dropFirst() { // second argument and onward, because the first argument seems to be the call to the file/command
	var dicePool = arg.characters

	guard let diceType = dicePool.popLast() else {
		print("the dice-type could not be determined from `\(arg)`")
		usage()
		exit(1)
	}

	if let num = Int(String(dicePool)) {
		rollDice(number: num, ofType: diceType)
	} else if dicePool.isEmpty {
		rollDice(number: 1, ofType: diceType)
	} else {
		print("the dice number could not be determined from `\(arg)`")
		usage()
	}
}

// count/calc each die face and output
output()
