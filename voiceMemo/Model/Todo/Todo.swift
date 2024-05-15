//
//  Todo.swift
//  voiceMemo
//

import Foundation

struct Todo: Hashable {
    var title: String
    var time: Date
    var day: Date
    var selected: Bool
    
    var converterDayAndTime: String {
        //오늘 오후 03:00에 알림
        String("\(day.foremattedDay) - \(time.foremattedTime)에 알림")
    }
}
