//
//  TaskService.swift
//  TestApp
//
//  Created by Jusung Han on 7/3/25.
//

import FirebaseFirestore

class TaskService {
    let db = Firestore.firestore()
    
    func addTask(for userId: String, task: Task, completion: @escaping (Error?) -> Void) {
        let taskData = task.toDict()
        db.collection("users")
            .document(userId)
            .collection("tasks")
            .addDocument(data: taskData, completion: completion)
    }
    
    func fetchTasks(for userId: String, completion: @escaping ([Task]?, Error?) -> Void) {
        db.collection("users")
            .document(userId)
            .collection("tasks")
            .order(by: "dueDate")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                } else {
                    let tasks: [Task] = snapshot?.documents.compactMap { doc in
                        return Task(from: doc.data(), id: doc.documentID)
                    } ?? []
                    completion(tasks, nil)
                }
            }
    }
    
    func updateTaskCompletion(userId: String, task: Task) {
        db.collection("users")
          .document(userId)
          .collection("tasks")
          .document(task.id)
          .updateData(["isCompleted": task.isCompleted]) { error in
              if let error = error {
                  print("Error updating task: \(error.localizedDescription)")
              }
          }
    }
}
