//
//  DataManager+Food.swift
//  Freshi
//
//  Created by Jinwook Huh on 2021/07/06.
//

import Foundation
import CoreData

extension DataManager {
    func createFood(name: String, date: String, count: Int, location: Int, image: Data? = nil, completion: (() -> ())? = nil) {
        mainContext.perform {
            let newFood = FoodEntity(context: self.mainContext)
            newFood.name = name
            newFood.date = date
            newFood.count = Int16(count)
            newFood.location = Int16(location)
            
            if let image = image {
                newFood.image = image
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    func fetchFood() -> [FoodEntity] {
        var list = [FoodEntity]()
        mainContext.performAndWait {
            let request: NSFetchRequest<FoodEntity> = FoodEntity.fetchRequest()
            
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        
        return list
    }
    
    func updateFood(entity: FoodEntity, name: String? = nil, date: String? = nil, count: Int? = nil, location: Int? = nil, image: Data? = nil, completion: (() -> ())? = nil) {
        mainContext.perform {
            
            if let name = name {
                entity.name = name
            }
            
            if let date = date {
                entity.date = date
            }
            
            if let count = count {
                entity.count = Int16(count)
            }
            
            if let location = location {
                entity.location = Int16(location)
            }
            
            if let image = image {
                entity.image = image
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    func delete(entity: FoodEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
    
}
