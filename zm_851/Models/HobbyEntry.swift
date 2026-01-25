import Foundation

struct HobbyEntry: Identifiable, Codable {
    var id = UUID()
    var hobbyName: String
    var date: Date
    var duration: Int // in minutes
    var notes: String
    var skillLevel: SkillLevel
    var achievements: [String]
    
    enum SkillLevel: String, Codable, CaseIterable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        case expert = "Expert"
    }
}
