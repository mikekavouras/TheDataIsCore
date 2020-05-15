//
//  Person+CoreDataProperties.swift
//  TheDataIsCore
//
//  Created by Mike Kavouras on 5/15/20.
//  Copyright © 2020 Mike Kavouras. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData

extension Person {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?

    class func all() -> Result<[Person], Error> {
        let application = (UIApplication.shared.delegate as! AppDelegate)
        let persistentContainer = application.persistentContainer
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let people = try context.fetch(fetchRequest)
            return .success(people)
        } catch {
            return .failure(error)
        }
    }
    
    class func save(name: String) -> Result<Person, Error> {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = Person(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        
        do {
            try managedContext.save()
            return .success(person)
        } catch let error as NSError {
            return .failure(error)
        }
    }
}
