//
//  Date+Extensions.swift
//  Task Management
//
//  Created by Panchenko Oleg on 02.08.2023.
//

import SwiftUI

extension Date {
    //Custom Date Format
    func format(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    //Checking whether the date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    //Checking if the date is same hour
    var isSameHour: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedSame
    }

    //Checking if the date is past hour
    var isPast: Bool {
        return Calendar.current.compare(self, to: .init(), toGranularity: .hour) == .orderedAscending
    }

    //Fetching week based on given Date
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)

        var week: [WeekDay] = []
        let weekOfDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekOfDate?.start else {
            return []
        }

        //Iterating to get full week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        return week
    }

    //Creating next week, based on the Last current week's date
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetchWeek(nextDate)
    }

    //Creating previous week, based on the first current week's date
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFistDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFistDate) else {
            return []
        }
        return fetchWeek(previousDate)
    }

    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}
