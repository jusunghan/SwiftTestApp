//
//  TaskView.swift
//  TestApp
//
//  Created by Jusung Han on 7/3/25.
//
import SwiftUI

struct TaskView: View {
    @StateObject private var viewModel: TaskViewModel
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Add New Task")){
                        TextField("Task Title", text: $viewModel.newTaskTitle)
                        DatePicker("Due Date", selection: $viewModel.newTaskDate, displayedComponents: .date)
                        Button("Add Task") {
                            viewModel.addTask(title: viewModel.newTaskTitle, dueDate: viewModel.newTaskDate)
                        }
                        .disabled(viewModel.newTaskTitle.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                
                List(viewModel.tasks) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.title).font(.headline)
                            Text("Due: \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(task.isCompleted ? .green : .gray)
                            .font(.title2)
                    }
                }
            }
            .navigationTitle("My Tasks")
        }
    }
}
