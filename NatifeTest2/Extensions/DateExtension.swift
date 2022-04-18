//
//  DateExtension.swift
//  NatifeTest2
//
//  Created by Danylo Klymov on 01.04.2022.
//

import Foundation

extension Date {
    static func timeshampToDateString(_ timeshamp: Int?) -> String {
        guard let timeshamp = timeshamp else { return "" }
        let date = Date(timeIntervalSince1970: Double(timeshamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+2")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
