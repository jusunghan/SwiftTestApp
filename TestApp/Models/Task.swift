//
//  Task.swift
//  TestApp
//
//  Created by Jusung Han on 7/3/25.
//

import Foundation
import FirebaseFirestore

struct Task: Identifiable {
    var id: String        
    var title: String
    var dueDate: Date
    var isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, dueDate: Date, isCompleted: Bool){
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.isCompleted = isCompleted
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let title = dict["title"] as? String,
              let timestamp = dict["dueDate"] as? Timestamp,
              let isCompleted = dict["isCompleted"] as? Bool else {
            return nil
        }
        self.id = id
        self.title = title
        self.dueDate = timestamp.dateValue()
        self.isCompleted = isCompleted
    }
    
    func toDict() -> [String: Any] {
        return [
            "title": title,
            "dueDate": dueDate,
            "isCompleted": isCompleted
        ]
    }
}
