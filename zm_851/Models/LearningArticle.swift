import Foundation

struct LearningArticle: Identifiable, Codable {
    var id = UUID()
    var title: String
    var category: Category
    var content: String
    var readingTime: Int // in minutes
    var isRead: Bool
    var dateAdded: Date
    
    enum Category: String, Codable, CaseIterable {
        case productivity = "Productivity"
        case mindfulness = "Mindfulness"
        case creativity = "Creativity"
        case leadership = "Leadership"
        case communication = "Communication"
        case wellness = "Wellness"
    }
}
