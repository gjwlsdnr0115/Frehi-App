//
//  SharedDateFormatter.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/06.
//

import UIKit

class SharedDateFormatter {
    var formatter: DateFormatter
    
    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
    }
    
    func getToday() -> String {
        let today = Date()
        let todayString = formatter.string(from: today)
        return todayString
    }
    
    func format(date: Date) -> String {
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    func stringToDate(dateString: String) -> Date {
        return formatter.date(from: dateString)!
    }
    
}
