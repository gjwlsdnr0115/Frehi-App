//
//  Date+Extension.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/06.
//

import UIKit


// operator to get difference between Dates
extension Date {

    static func -(first: Date, second: Date) -> Int {
        
        if first >= second {
            let day = Calendar.current.dateComponents([.day], from: second, to: first).day
            return day!
        } else {
            let day = Calendar.current.dateComponents([.day], from: first, to: second).day
            return -1 * day!
        }

    }

}
