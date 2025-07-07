//
//  Message.swift
//  TestApp
//
//  Created by Jusung Han on 7/6/25.
//
import Foundation

struct Message: Identifiable {
    var id: String
    var text: String
    var senderId: String
    var timestamp: Date
}
