import Foundation
import Combine

class DailyGoalsViewModel: ObservableObject {
    @Published var goals: [Goal] = []
    
    private let dataService = DataService.shared
    
    init() {
        loadGoals()
    }
    
    func loadGoals() {
        goals = dataService.loadGoals()
    }
    
    func addGoal(title: String, description: String, priority: Goal.Priority) {
        let newGoal = Goal(
            title: title,
            description: description,
            isCompleted: false,
            createdDate: Date(),
            priority: priority
        )
        goals.append(newGoal)
        saveGoals()
    }
    
    func toggleGoalCompletion(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index].isCompleted.toggle()
            goals[index].completedDate = goals[index].isCompleted ? Date() : nil
            saveGoals()
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
        saveGoals()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    private func saveGoals() {
        dataService.saveGoals(goals)
    }
    
    var completedGoalsCount: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    var pendingGoalsCount: Int {
        goals.filter { !$0.isCompleted }.count
    }
    
    var completionRate: Double {
        guard !goals.isEmpty else { return 0 }
        return Double(completedGoalsCount) / Double(goals.count)
    }
}
