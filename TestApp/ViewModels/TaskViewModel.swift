//
//  TaskViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 7/3/25.
//

import Foundation
import Combine

class TaskViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var newTaskTitle: String = ""
    @Published var newTaskDate: Date = Date()
    
    private let taskService = TaskService()
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
        loadTasks()
    }
    
    func loadTasks() {
        taskService.fetchTasks(for: userId) { tasks, error in
            if let tasks = tasks {
                DispatchQueue.main.async {
                    self.tasks = tasks
                }
            } else {
                print("Fetch error: \(error?.localizedDescription ?? "unknown")")
            }
        }
    }
    
    func addTask(title: String, dueDate: Date) {
        let newTask = Task(title: title, dueDate: dueDate, isCompleted: false)
        taskService.addTask(for: userId, task: newTask) { error in
            if error == nil {
                self.newTaskTitle = ""
                self.newTaskDate = Date()
                self.loadTasks()
            } else {
                print("Add error: \(error!.localizedDescription)")
            }
        }
    }
    
    func updateTaskCompletion(userId: String, task: Task){
        taskService.updateTaskCompletion(userId: userId, task: task)
    }
}
