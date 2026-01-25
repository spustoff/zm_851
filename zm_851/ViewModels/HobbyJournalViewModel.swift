import Foundation
import Combine

class HobbyJournalViewModel: ObservableObject {
    @Published var entries: [HobbyEntry] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadEntries()
    }
    
    func loadEntries() {
        entries = dataService.loadHobbyEntries()
    }
    
    func addEntry(hobbyName: String, duration: Int, notes: String, skillLevel: HobbyEntry.SkillLevel, achievements: [String]) {
        let newEntry = HobbyEntry(
            hobbyName: hobbyName,
            date: Date(),
            duration: duration,
            notes: notes,
            skillLevel: skillLevel,
            achievements: achievements
        )
        entries.append(newEntry)
        saveEntries()
    }
    
    func deleteEntry(_ entry: HobbyEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func updateEntry(_ entry: HobbyEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    private func saveEntries() {
        dataService.saveHobbyEntries(entries)
    }
    
    func getTotalTimeFor(hobby: String) -> Int {
        entries.filter { $0.hobbyName == hobby }.reduce(0) { $0 + $1.duration }
    }
    
    func getUniqueHobbies() -> [String] {
        Array(Set(entries.map { $0.hobbyName })).sorted()
    }
    
    func getEntriesFor(hobby: String) -> [HobbyEntry] {
        entries.filter { $0.hobbyName == hobby }.sorted { $0.date > $1.date }
    }
}
