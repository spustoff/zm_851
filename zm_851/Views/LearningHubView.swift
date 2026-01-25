import SwiftUI

struct LearningHubView: View {
    @StateObject private var viewModel = LearningHubViewModel()
    @State private var selectedArticle: LearningArticle?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category Filter
                    categoryScrollView
                        .padding(.vertical, 10)
                    
                    // Stats
                    statsView
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                    
                    // Articles List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredArticles) { article in
                                ArticleRow(article: article)
                                    .onTapGesture {
                                        selectedArticle = article
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Learning Hub")
            .navigationBarTitleDisplayMode(.large)
            .sheet(item: $selectedArticle) { article in
                ArticleDetailView(article: article, viewModel: viewModel, isPresented: $selectedArticle)
            }
        }
    }
    
    var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                CategoryChip(
                    title: "All",
                    isSelected: viewModel.selectedCategory == nil,
                    action: { viewModel.selectedCategory = nil }
                )
                
                ForEach(LearningArticle.Category.allCases, id: \.self) { category in
                    CategoryChip(
                        title: category.rawValue,
                        isSelected: viewModel.selectedCategory == category,
                        action: { viewModel.selectedCategory = category }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    var statsView: some View {
        HStack(spacing: 15) {
            HStack(spacing: 8) {
                Image(systemName: "book.fill")
                    .foregroundColor(Color(hex: "F3DA36"))
                Text("\(viewModel.readArticlesCount) Read")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.15))
            .cornerRadius(8)
            
            HStack(spacing: 8) {
                Image(systemName: "book.closed.fill")
                    .foregroundColor(Color(hex: "500180"))
                Text("\(viewModel.unreadArticlesCount) Unread")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.15))
            .cornerRadius(8)
            
            Spacer()
        }
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? Color(hex: "B40814") : .white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "F3DA36") : Color.white.opacity(0.2))
                .cornerRadius(20)
        }
    }
}

struct ArticleRow: View {
    let article: LearningArticle
    
    var body: some View {
        HStack(spacing: 15) {
            categoryIcon(article.category)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(article.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("\(article.readingTime) min")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.white.opacity(0.7))
                    
                    Text(article.category.rawValue)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "F3DA36"))
                    
                    if article.isRead {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 12))
                            Text("Read")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(hex: "500180"))
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.5))
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
    
    func categoryIcon(_ category: LearningArticle.Category) -> some View {
        let iconName: String
        switch category {
        case .productivity:
            iconName = "chart.bar.fill"
        case .mindfulness:
            iconName = "sparkles"
        case .creativity:
            iconName = "paintbrush.fill"
        case .leadership:
            iconName = "person.3.fill"
        case .communication:
            iconName = "bubble.left.and.bubble.right.fill"
        case .wellness:
            iconName = "heart.fill"
        }
        
        return Image(systemName: iconName)
            .font(.system(size: 24))
            .foregroundColor(Color(hex: "500180"))
            .frame(width: 50, height: 50)
            .background(Color.white.opacity(0.2))
            .cornerRadius(10)
    }
}

struct ArticleDetailView: View {
    let article: LearningArticle
    @ObservedObject var viewModel: LearningHubViewModel
    @Binding var isPresented: LearningArticle?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Header
                        VStack(alignment: .leading, spacing: 12) {
                            Text(article.category.rawValue)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(hex: "F3DA36"))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                            
                            Text(article.title)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            HStack(spacing: 15) {
                                HStack(spacing: 5) {
                                    Image(systemName: "clock")
                                    Text("\(article.readingTime) min read")
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                                
                                HStack(spacing: 5) {
                                    Image(systemName: "calendar")
                                    Text(article.dateAdded, style: .date)
                                }
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        
                        Divider()
                            .background(Color.white.opacity(0.3))
                        
                        // Content
                        Text(article.content)
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                            .lineSpacing(8)
                        
                        // Mark as Read Button
                        Button(action: {
                            viewModel.toggleReadStatus(article)
                        }) {
                            HStack {
                                Image(systemName: article.isRead ? "checkmark.circle.fill" : "circle")
                                Text(article.isRead ? "Mark as Unread" : "Mark as Read")
                            }
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: "B40814"))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "F3DA36"))
                            .cornerRadius(12)
                        }
                        .padding(.top, 10)
                    }
                    .padding()
                }
            }
            .navigationTitle("Article")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = nil
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
        }
    }
}
