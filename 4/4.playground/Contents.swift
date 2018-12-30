import Foundation

func getInput() -> String {
	let fileName = "input.txt"
	
	let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	
	let fileURL = dir.appendingPathComponent(fileName)
	
	return try! String(contentsOf: fileURL, encoding: .utf8)
}

let inputFileString = getInput()

let prefixIndex = 17

enum Event {
	case beginsShift(Int)
	case wakesUp(Int)
	case fallsAsleep(Int)
	
	static func parse(string: String) -> Event {
		let suffix = string.suffix(string.count - prefixIndex)
		if string.contains("Guard") {
			let idStr = suffix
				.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789").inverted)
			return Event.beginsShift(Int(idStr)!)
		}
		
		let min = Int(string.prefix(prefixIndex).suffix(2))!
		return suffix.contains("falls") ? .fallsAsleep(min) : .wakesUp(min)
	}
}


func organizeLogs(inputStr: String) -> [String] {
	// Organize the logs into chronological order
	let organizedLogs = inputStr
		.lazy
		.split(separator: "\n")
		.sorted(by: { $0.prefix(prefixIndex) < $1.prefix(prefixIndex) })
		.map { String($0) }
	return organizedLogs
}

struct Session {
	let guardId: Int
	let events: [Event]
}

func organizeSessions(organizedLogs: [String]) -> [Session] {
	var sessions = [Session]()
	var curId: Int? = nil
	var curEvents = [Event]()
	for log in organizedLogs {
		let curEvent = Event.parse(string: log)
		switch curEvent {
		case .beginsShift(let id):
			if let prevId = curId {
				sessions.append(Session(guardId: prevId, events: curEvents))
			}
			curId = id
			curEvents = []
		default:
			curEvents.append(curEvent)
		}
	}
	return sessions
}

let organizedSessions = organizeSessions(organizedLogs: organizeLogs(inputStr: inputFileString))

// Find out who's the guard with the most sleeping time
var guardsAndSleepTimes = [Int:Int]()
var guardsAndSleepRanges = [Int: [[(Int, Int)]]]()
organizedSessions.forEach { (session) in
	var totalSleepTime = 0
	var lastSleep = 0
	var curTimes = [(Int, Int)]()
	for event in session.events {
		switch event {
		case .fallsAsleep(let min):
			lastSleep = min
		case .wakesUp(let min):
			totalSleepTime += min - lastSleep
			curTimes.append((min, lastSleep))
		default:
			continue
		}
	}
	
	guardsAndSleepTimes.updateValue((guardsAndSleepTimes[session.guardId] ?? 0) + totalSleepTime,
									forKey: session.guardId)
	var newArr = guardsAndSleepRanges[session.guardId]
	if newArr == nil {
		newArr = [curTimes]
	} else {
		var duplicate = newArr!
		duplicate.append(curTimes)
		newArr = duplicate
	}
	guardsAndSleepRanges[session.guardId] = newArr
}

var mostId = 0
var mostSleepTime = 0
for (id, sleepTime) in guardsAndSleepTimes {
	if sleepTime > mostSleepTime {
		mostSleepTime = sleepTime
		mostId = id
	}
}

func getMaxMinuteAndCount(for guardId: Int) -> (Int, Int) {
	let ranges = guardsAndSleepRanges[guardId]!
		.joined()
		.map { $0.1..<$0.0 }
	
	var minuteCounts = [Int:Int]()
	for range in ranges {
		for i in range {
			minuteCounts.updateValue((minuteCounts[i] ?? 0) + 1, forKey: i)
		}
	}
	
	var maxMin = 0
	var maxCount = 0
	for (min, count) in minuteCounts {
		if count > maxCount {
			maxCount = count
			maxMin = min
		}
	}
	
	return (maxMin, maxCount)
}

// Part one solution:
print(mostId * getMaxMinuteAndCount(for: mostId).0)


var winnerMaxMin = 0
var winnerMaxCount = 0
var winnerGuard = 0
for guardId in guardsAndSleepRanges.keys {
	let tuple = getMaxMinuteAndCount(for: guardId)
	if winnerMaxCount < tuple.1 {
		winnerMaxCount = tuple.1
		winnerMaxMin = tuple.0
		winnerGuard = guardId
	}
}

// Part two solution:
print(winnerGuard * winnerMaxMin)
