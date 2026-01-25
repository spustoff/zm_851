import Foundation
import Combine

class LearningHubViewModel: ObservableObject {
    @Published var articles: [LearningArticle] = []
    @Published var selectedCategory: LearningArticle.Category?
    
    private let dataService = DataService.shared
    
    init() {
        loadArticles()
    }
    
    func loadArticles() {
        articles = dataService.loadArticles()
    }
    
    func toggleReadStatus(_ article: LearningArticle) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isRead.toggle()
            saveArticles()
        }
    }
    
    func addArticle(title: String, category: LearningArticle.Category, content: String, readingTime: Int) {
        let newArticle = LearningArticle(
            title: title,
            category: category,
            content: content,
            readingTime: readingTime,
            isRead: false,
            dateAdded: Date()
        )
        articles.append(newArticle)
        saveArticles()
    }
    
    func deleteArticle(_ article: LearningArticle) {
        articles.removeAll { $0.id == article.id }
        saveArticles()
    }
    
    private func saveArticles() {
        dataService.saveArticles(articles)
    }
    
    var filteredArticles: [LearningArticle] {
        if let category = selectedCategory {
            return articles.filter { $0.category == category }
        }
        return articles
    }
    
    var readArticlesCount: Int {
        articles.filter { $0.isRead }.count
    }
    
    var unreadArticlesCount: Int {
        articles.filter { !$0.isRead }.count
    }
}
