import Foundation

struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var frequency: Frequency
    var createdDate: Date
    var completionDates: [Date]
    var targetDaysPerWeek: Int
    
    enum Frequency: String, Codable, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case custom = "Custom"
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        return completionDates.contains { calendar.isDateInToday($0) }
    }
    
    func completionRate(for days: Int = 30) -> Double {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        let completedInRange = completionDates.filter { $0 >= startDate }.count
        return Double(completedInRange) / Double(days)
    }
}
