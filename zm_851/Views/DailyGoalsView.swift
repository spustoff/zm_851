import SwiftUI

struct DailyGoalsView: View {
    @StateObject private var viewModel = DailyGoalsViewModel()
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Stats Header
                    statsHeader
                        .padding()
                    
                    // Goals List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.goals) { goal in
                                GoalRow(goal: goal, viewModel: viewModel)
                                    .onTapGesture {
                                        selectedGoal = goal
                                    }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Daily Goals")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddGoal = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color(hex: "F3DA36"))
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoal) {
                AddGoalView(viewModel: viewModel)
            }
            .sheet(item: $selectedGoal) { goal in
                GoalDetailView(goal: goal, viewModel: viewModel, isPresented: $selectedGoal)
            }
        }
    }
    
    var statsHeader: some View {
        HStack(spacing: 20) {
            StatCard(
                title: "Completed",
                value: "\(viewModel.completedGoalsCount)",
                color: "F3DA36"
            )
            
            StatCard(
                title: "Pending",
                value: "\(viewModel.pendingGoalsCount)",
                color: "500180"
            )
            
            StatCard(
                title: "Rate",
                value: String(format: "%.0f%%", viewModel.completionRate * 100),
                color: "F3DA36"
            )
        }
    }
}

struct GoalRow: View {
    let goal: Goal
    @ObservedObject var viewModel: DailyGoalsViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            Button(action: {
                withAnimation {
                    viewModel.toggleGoalCompletion(goal)
                }
            }) {
                Image(systemName: goal.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(goal.isCompleted ? Color(hex: "F3DA36") : .white.opacity(0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(goal.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .strikethrough(goal.isCompleted)
                
                if !goal.description.isEmpty {
                    Text(goal.description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(2)
                }
                
                HStack {
                    priorityBadge(goal.priority)
                    
                    Spacer()
                    
                    Text(goal.createdDate, style: .date)
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteGoal(goal)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    func priorityBadge(_ priority: Goal.Priority) -> some View {
        Text(priority.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(priorityColor(priority))
            .cornerRadius(6)
    }
    
    func priorityColor(_ priority: Goal.Priority) -> Color {
        switch priority {
        case .high:
            return Color.red.opacity(0.7)
        case .medium:
            return Color.orange.opacity(0.7)
        case .low:
            return Color.green.opacity(0.7)
        }
    }
}

struct AddGoalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: DailyGoalsViewModel
    
    @State private var title = ""
    @State private var description = ""
    @State private var priority: Goal.Priority = .medium
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                Form {
                    Section(header: Text("Goal Details")) {
                        TextField("Title", text: $title)
                        TextField("Description (optional)", text: $description)
                        
                        Picker("Priority", selection: $priority) {
                            ForEach(Goal.Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            .navigationTitle("New Goal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(Color(hex: "F3DA36"))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        viewModel.addGoal(title: title, description: description, priority: priority)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(title.isEmpty)
                    .foregroundColor(Color(hex: "F3DA36"))
                }
            }
        }
    }
}

struct GoalDetailView: View {
    let goal: Goal
    @ObservedObject var viewModel: DailyGoalsViewModel
    @Binding var isPresented: Goal?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "B40814")
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(goal.title)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        if !goal.description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(goal.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Priority")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(goal.priority.rawValue)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Status")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(goal.isCompleted ? "Completed" : "Pending")
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Created")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.7))
                            
                            Text(goal.createdDate, style: .date)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        
                        if let completedDate = goal.completedDate {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Completed")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.7))
                                
                                Text(completedDate, style: .date)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Button(action: {
                            viewModel.toggleGoalCompletion(goal)
                            isPresented = nil
                        }) {
                            Text(goal.isCompleted ? "Mark as Pending" : "Mark as Completed")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(Color(hex: "B40814"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(hex: "F3DA36"))
                                .cornerRadius(12)
                        }
                        .padding(.top)
                    }
                    .padding()
                }
            }
            .navigationTitle("Goal Details")
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

struct StatCard: View {
    let title: String
    let value: String
    let color: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(hex: color))
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}
