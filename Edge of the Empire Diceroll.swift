import Darwin // for arc4random_uniform
import Foundation

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
	if roll.isEmpty {
		print("Blank/neutral roll")
		return
	}

	// counts occurrences by counting the elements in a new array formed only of the matching items in `roll`
	var start = Date()
	var successes = 0
	var failures = 0
	var advantages = 0
	var threats = 0
	var light = 0
	var dark = 0
	var triumphs = 0
	var despairs = 0
	for elem in roll {
		switch elem {
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
		default:
			continue
		}
	}
	var end = Date()
	print("count: \(end.timeIntervalSince(start))")

	start = Date()
	if successes + triumphs - despairs - threats > 0 {
		print("SUCCESS!")
	} else {
		print("FAILURE!")
	}
	// Success/Failure
	if successes > 0 {
		print("\(successes) Success" + (successes > 1 ? "es":""))
	}
	if failures > 0 {
		print("\(failures) Failure" + (failures > 1 ? "s":""))
	}
	// Advantage/Threat
	if advantages > 0 {
		print("\(advantages) Advantage" + (advantages > 1 ? "s":""))
	}
	if threats > 0 {
		print("\(threats) Threat" + (threats > 1 ? "s":""))
	}
	// Triumph/Despair
	if triumphs > 0 {
		print("\(triumphs) Triumph" + (triumphs > 1 ? "s":""))
	}
	if despairs > 0 {
		print("\(despairs) Despair" + (despairs > 1 ? "s":""))
	}
	// Light/Dark
	if light > 0 {
		print("\(light) Light Side" + (light > 1 ? "s":""))
	}
	if dark > 0 {
		print("\(dark) Dark Side" + (dark > 1 ? "s":""))
	}
	end = Date()
	print("output: \(end.timeIntervalSince(start))")
}

// let start1 = Date()
var roll: [Symbol] = []
//parses the command line argument for the number and type of dice to roll
let start = Date()
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
let end = Date()
print("parse: \(end.timeIntervalSince(start))")

// count/calc each die face and output
output()
// let end1 = Date()
// print("total: \(end1.timeIntervalSince(start1))")
