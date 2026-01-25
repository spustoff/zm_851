import Foundation
import Combine

class HabitTrackerViewModel: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadHabits()
    }
    
    func loadHabits() {
        habits = dataService.loadHabits()
    }
    
    func addHabit(name: String, description: String, frequency: Habit.Frequency, targetDaysPerWeek: Int) {
        let newHabit = Habit(
            name: name,
            description: description,
            frequency: frequency,
            createdDate: Date(),
            completionDates: [],
            targetDaysPerWeek: targetDaysPerWeek
        )
        habits.append(newHabit)
        saveHabits()
    }
    
    func toggleHabitCompletion(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            if let existingIndex = habits[index].completionDates.firstIndex(where: { 
                calendar.isDate($0, inSameDayAs: today)
            }) {
                habits[index].completionDates.remove(at: existingIndex)
            } else {
                habits[index].completionDates.append(today)
            }
            saveHabits()
        }
    }
    
    func deleteHabit(_ habit: Habit) {
        habits.removeAll { $0.id == habit.id }
        saveHabits()
    }
    
    func updateHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
            saveHabits()
        }
    }
    
    private func saveHabits() {
        dataService.saveHabits(habits)
    }
    
    func getStreakFor(_ habit: Habit) -> Int {
        guard !habit.completionDates.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedDates = habit.completionDates.sorted(by: >)
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        for date in sortedDates {
            let completionDate = calendar.startOfDay(for: date)
            if calendar.isDate(completionDate, inSameDayAs: currentDate) {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        
        return streak
    }
}
