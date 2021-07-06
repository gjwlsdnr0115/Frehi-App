//
//  FoodEntity+CoreDataProperties.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/05.
//
//

import Foundation
import CoreData


extension FoodEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntity> {
        return NSFetchRequest<FoodEntity>(entityName: "Food")
    }

    @NSManaged public var location: Int16
    @NSManaged public var name: String?
    @NSManaged public var count: Int16
    @NSManaged public var date: String?
    @NSManaged public var image: Data?

}

extension FoodEntity : Identifiable {

}
