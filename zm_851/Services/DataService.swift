import Foundation

class DataService {
    static let shared = DataService()
    
    private init() {}
    
    // MARK: - Goals
    func saveGoals(_ goals: [Goal]) {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: "savedGoals")
        }
    }
    
    func loadGoals() -> [Goal] {
        if let data = UserDefaults.standard.data(forKey: "savedGoals"),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            return decoded
        }
        return []
    }
    
    // MARK: - Habits
    func saveHabits(_ habits: [Habit]) {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "savedHabits")
        }
    }
    
    func loadHabits() -> [Habit] {
        if let data = UserDefaults.standard.data(forKey: "savedHabits"),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            return decoded
        }
        return []
    }
    
    // MARK: - Learning Articles
    func saveArticles(_ articles: [LearningArticle]) {
        if let encoded = try? JSONEncoder().encode(articles) {
            UserDefaults.standard.set(encoded, forKey: "savedArticles")
        }
    }
    
    func loadArticles() -> [LearningArticle] {
        if let data = UserDefaults.standard.data(forKey: "savedArticles"),
           let decoded = try? JSONDecoder().decode([LearningArticle].self, from: data) {
            return decoded
        }
        return getDefaultArticles()
    }
    
    // MARK: - Hobby Entries
    func saveHobbyEntries(_ entries: [HobbyEntry]) {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "savedHobbyEntries")
        }
    }
    
    func loadHobbyEntries() -> [HobbyEntry] {
        if let data = UserDefaults.standard.data(forKey: "savedHobbyEntries"),
           let decoded = try? JSONDecoder().decode([HobbyEntry].self, from: data) {
            return decoded
        }
        return []
    }
    
    // MARK: - Reset All Data
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: "savedGoals")
        UserDefaults.standard.removeObject(forKey: "savedHabits")
        UserDefaults.standard.removeObject(forKey: "savedArticles")
        UserDefaults.standard.removeObject(forKey: "savedHobbyEntries")
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
    }
    
    // MARK: - Default Content
    private func getDefaultArticles() -> [LearningArticle] {
        return [
            LearningArticle(
                title: "The Power of Morning Routines",
                category: .productivity,
                content: """
                Creating a consistent morning routine can transform your entire day. Research shows that successful individuals often share similar morning habits: they wake up early, exercise, meditate, and plan their day.
                
                Key Benefits:
                • Increased energy and focus
                • Better stress management
                • Enhanced productivity
                • Improved mental clarity
                
                Start small - choose one habit to implement this week. Whether it's a 5-minute meditation or a glass of water upon waking, consistency matters more than perfection.
                
                Tips for Success:
                1. Prepare the night before
                2. Start with 15-minute blocks
                3. Track your progress
                4. Adjust as needed
                
                Remember, your morning routine should energize you, not drain you. Experiment to find what works best for your lifestyle.
                """,
                readingTime: 5,
                isRead: false,
                dateAdded: Date()
            ),
            LearningArticle(
                title: "Mindfulness in Daily Life",
                category: .mindfulness,
                content: """
                Mindfulness isn't just about meditation—it's about being present in every moment of your life. This practice can reduce stress, improve focus, and enhance overall well-being.
                
                What is Mindfulness?
                Mindfulness means paying attention to the present moment without judgment. It's observing your thoughts, feelings, and surroundings with curiosity and acceptance.
                
                Daily Mindfulness Practices:
                • Mindful breathing (2-5 minutes)
                • Body scan meditation
                • Mindful eating
                • Walking meditation
                • Gratitude journaling
                
                Scientific Benefits:
                Studies show mindfulness can reduce anxiety, improve sleep quality, enhance emotional regulation, and boost immune function.
                
                Getting Started:
                Begin with just 2 minutes a day. Find a quiet space, focus on your breath, and gently return your attention when your mind wanders. There's no "wrong" way to practice.
                
                The key is consistency. Even a few minutes daily can create lasting positive changes in your brain and behavior.
                """,
                readingTime: 6,
                isRead: false,
                dateAdded: Date()
            ),
            LearningArticle(
                title: "Unlocking Your Creative Potential",
                category: .creativity,
                content: """
                Everyone is creative—it's not a talent reserved for artists and musicians. Creativity is a skill you can develop through practice and the right mindset.
                
                Breaking Creative Blocks:
                • Change your environment
                • Try new experiences
                • Embrace constraints
                • Practice free-form brainstorming
                • Collaborate with others
                
                The Creative Process:
                1. Preparation - Gather information
                2. Incubation - Let ideas simmer
                3. Illumination - The "aha!" moment
                4. Verification - Test and refine
                
                Daily Creative Habits:
                Set aside 15 minutes for creative exploration without judgment. Draw, write, photograph, or simply observe the world with fresh eyes.
                
                Remember: Creativity thrives on curiosity, not perfection. Give yourself permission to experiment, fail, and learn. Your unique perspective is valuable.
                
                Start today: Choose one creative activity you've been curious about and commit to trying it this week.
                """,
                readingTime: 5,
                isRead: false,
                dateAdded: Date()
            ),
            LearningArticle(
                title: "Effective Communication Skills",
                category: .communication,
                content: """
                Communication is the foundation of all relationships—personal and professional. Mastering this skill can transform your life.
                
                Active Listening:
                The most important communication skill is listening. This means:
                • Giving full attention
                • Avoiding interruptions
                • Asking clarifying questions
                • Reflecting back what you heard
                
                Clear Expression:
                • Be concise and specific
                • Use "I" statements
                • Match your tone to your message
                • Consider your audience
                
                Non-Verbal Communication:
                Body language, eye contact, and facial expressions often speak louder than words. Ensure your non-verbal cues align with your message.
                
                Difficult Conversations:
                1. Choose the right time and place
                2. Stay calm and objective
                3. Focus on solutions
                4. Practice empathy
                
                Remember: Communication is a two-way street. The goal isn't just to be heard, but to create understanding and connection.
                """,
                readingTime: 5,
                isRead: false,
                dateAdded: Date()
            ),
            LearningArticle(
                title: "Building Emotional Wellness",
                category: .wellness,
                content: """
                Emotional wellness is about understanding and managing your emotions in healthy ways. It's a crucial component of overall well-being.
                
                Pillars of Emotional Wellness:
                • Self-awareness
                • Emotional regulation
                • Resilience
                • Healthy relationships
                • Purpose and meaning
                
                Daily Practices:
                1. Check in with your emotions regularly
                2. Journal your thoughts and feelings
                3. Practice self-compassion
                4. Set healthy boundaries
                5. Seek support when needed
                
                Stress Management:
                • Deep breathing exercises
                • Physical movement
                • Time in nature
                • Creative expression
                • Social connection
                
                Building Resilience:
                Resilience isn't about avoiding difficulties—it's about bouncing back. Develop a growth mindset, maintain perspective, and learn from challenges.
                
                Remember: Taking care of your emotional health is not selfish—it's essential. You can't pour from an empty cup.
                """,
                readingTime: 6,
                isRead: false,
                dateAdded: Date()
            ),
            LearningArticle(
                title: "Leadership Through Service",
                category: .leadership,
                content: """
                True leadership isn't about authority—it's about inspiring and empowering others to achieve their potential.
                
                Servant Leadership Principles:
                • Put others first
                • Listen actively
                • Build trust
                • Empower team members
                • Lead by example
                
                Essential Leadership Skills:
                1. Vision - See the bigger picture
                2. Communication - Share your vision clearly
                3. Empathy - Understand others' perspectives
                4. Adaptability - Navigate change gracefully
                5. Integrity - Align actions with values
                
                Developing Leadership:
                Leadership can be learned. Start by leading yourself—manage your time, emotions, and commitments effectively. Then extend that discipline to helping others.
                
                Daily Leadership Practice:
                • Mentor someone
                • Ask "How can I help?"
                • Recognize others' contributions
                • Take responsibility
                • Stay humble
                
                Remember: Leadership is influence, and you have opportunities to lead every day—in your family, community, and workplace.
                """,
                readingTime: 5,
                isRead: false,
                dateAdded: Date()
            )
        ]
    }
}
