//
//  Task.swift
//  Task Management
//
//  Created by Panchenko Oleg on 02.08.2023.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var taskTitle: String
    var creationDate: Date = .init()
    var isCompleted: Bool = false
    var tint: Color
}

var sampleTasks: [Task] = [
    .init(taskTitle: "Record Video", creationDate: .updateHour(-5), isCompleted: true, tint: .taskColor1),
    .init(taskTitle: "Redesign Website", creationDate: .updateHour(-3), tint: .taskColor2),
    .init(taskTitle: "Go for a Walk", creationDate: .updateHour(-4), tint: .taskColor3),
    .init(taskTitle: "Edit Video", creationDate: .updateHour(0), isCompleted: true, tint: .taskColor4),
    .init(taskTitle: "Publish Video", creationDate: .updateHour(2), isCompleted: true, tint: .taskColor1),
    .init(taskTitle: "Tweet about new Video", creationDate: .updateHour(1), tint: .taskColor5)
]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}

extension Color {
    static let taskColor1 = Color("TaskColor 1")
    static let taskColor2 = Color("TaskColor 2")
    static let taskColor3 = Color("TaskColor 3")
    static let taskColor4 = Color("TaskColor 4")
    static let taskColor5 = Color("TaskColor 5")
}
