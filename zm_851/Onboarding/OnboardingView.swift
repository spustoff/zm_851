import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            Color(hex: "B40814")
                .ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                OnboardingPage1()
                    .tag(0)
                
                OnboardingPage2()
                    .tag(1)
                
                OnboardingPage3()
                    .tag(2)
                
                OnboardingPage4(hasCompletedOnboarding: $hasCompletedOnboarding)
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "chart.line.uptrend.xyaxis")
                .font(.system(size: 100))
                .foregroundColor(Color(hex: "F3DA36"))
            
            Text("Welcome to LifeAdvance")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Your personal companion for growth, productivity, and self-improvement")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Text("Swipe to continue")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "F3DA36"))
                .padding(.bottom, 50)
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            HStack(spacing: 20) {
                FeatureIcon(icon: "target", color: "F3DA36")
                FeatureIcon(icon: "calendar.badge.checkmark", color: "500180")
            }
            
            Text("Track Your Progress")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "checkmark.circle.fill", text: "Set and achieve daily goals")
                FeatureRow(icon: "repeat.circle.fill", text: "Build lasting habits")
                FeatureRow(icon: "chart.bar.fill", text: "Monitor your progress")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Text("Swipe to continue")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "F3DA36"))
                .padding(.bottom, 50)
        }
        .padding()
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            HStack(spacing: 20) {
                FeatureIcon(icon: "book.fill", color: "500180")
                FeatureIcon(icon: "paintbrush.fill", color: "F3DA36")
            }
            
            Text("Learn & Grow")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 15) {
                FeatureRow(icon: "lightbulb.fill", text: "Access curated learning resources")
                FeatureRow(icon: "brain.head.profile", text: "Develop new skills")
                FeatureRow(icon: "star.fill", text: "Journal your hobby progress")
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Text("Swipe to continue")
                .font(.system(size: 16))
                .foregroundColor(Color(hex: "F3DA36"))
                .padding(.bottom, 50)
        }
        .padding()
    }
}

struct OnboardingPage4: View {
    @Binding var hasCompletedOnboarding: Bool
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "sparkles")
                .font(.system(size: 100))
                .foregroundColor(Color(hex: "F3DA36"))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
            
            Text("Ready to Start?")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            Text("Begin your journey to a better you")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Button(action: {
                hasCompletedOnboarding = true
            }) {
                Text("Get Started")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(hex: "B40814"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "F3DA36"))
                    .cornerRadius(16)
            }
            .padding(.horizontal, 40)
            .padding(.top, 20)
            
            Spacer()
        }
        .padding()
        .onAppear {
            isAnimating = true
        }
    }
}

struct FeatureIcon: View {
    let icon: String
    let color: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 50))
            .foregroundColor(Color(hex: color))
            .frame(width: 80, height: 80)
            .background(Color.white.opacity(0.2))
            .cornerRadius(20)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "F3DA36"))
                .font(.system(size: 20))
            
            Text(text)
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
    }
}
