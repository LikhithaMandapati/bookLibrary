//
//  BooksListCRUD.swift
//  Books2
//
//  Created by Likhitha Mandapati on 1/13/24.
//

import UIKit
import CoreData

class BooksListCRUD: NSObject {

    static func create(newTitle:String, newAuthor:String, newSubName:String, newDueDate:Date) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            //Create a new empty record.
            let bookListEntity = NSEntityDescription.entity(forEntityName: "BooksList", in: managedContext)!
            //Fill the new record with values
            let books = NSManagedObject(entity: bookListEntity, insertInto: managedContext)
            books.setValue(newTitle, forKeyPath: "title")
            books.setValue(newAuthor, forKey: "author")
            books.setValue(newSubName, forKey: "subjectName")
            books.setValue(newDueDate, forKey: "dueDate")
            
            do {
                //Save the managed object context
                try managedContext.save()
            } catch let error as NSError {
                print("Could not create the new record! \(error), \(error.userInfo)")
            }
        }
    }
    
    
    static func read(title:String) -> [String: Any]? {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity (SELECT * FROM)
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksList")
            //Add a contition to the fetch request (WHERE)
            fetchRequest.predicate = NSPredicate(format: "title = %@", title)
            //Add a sorting preference (ORDER BY)
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "dueDate", ascending: true)]
    
            do {
                //Execute the fetch request
                let result = try managedContext.fetch(fetchRequest)
                if result.count > 0 {
                    if let record = result.first as? NSManagedObject {
                        let author = record.value(forKey: "author") as! String
                        let subName = record.value(forKey: "subjectName") as! String
                        let dueDate = record.value(forKey: "dueDate") as! Date
                        
                        let bookData: [String: Any] = ["title": title, "author": author, "subjectName": subName, "dueDate": dueDate]
                        
                        return bookData
                    }
                }
            } catch let error as NSError {
                print("Could not fetch the record! \(error), \(error.userInfo)")
            }
        }
        return nil
    }
    
    
    static func delete(oldTitle: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksList")
            fetchRequest.predicate = NSPredicate(format: "title = %@", oldTitle)
            
            do {
                let test = try managedContext.fetch(fetchRequest)
                
                // Check if the array is not empty before accessing its elements
                if !test.isEmpty {
                    let objectToDelete = test[0] as! NSManagedObject
                    print("objectToDelete: \(objectToDelete)")
                    
                    // Delete the record
                    managedContext.delete(objectToDelete)
                    
                    do {
                        // Save the managed object context
                        try managedContext.save()
                        print("Record deleted successfully.")
                    } catch let error as NSError {
                        print("Could not save the managed object context after deletion! \(error), \(error.userInfo)")
                    }
                } else {
                    print("No record found for deletion.")
                }
            } catch let error as NSError {
                print("Could not fetch the record to delete! \(error), \(error.userInfo)")
            }
        }
    }

    
    
    static func update(oldTitle:String, newTitle:String, newAuthor:String, newSubName:String, newDueDate:Date ) {
        //Get the managed context context from AppDelegate
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare a fetch request for the record to update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksList")
            fetchRequest.predicate = NSPredicate(format: "title = %@", oldTitle)
            
            do{
                //Fetch the record to update
                let test = try managedContext.fetch(fetchRequest)
                //Update the record
                let objectToUpdate = test[0] as! NSManagedObject
                objectToUpdate.setValue(newTitle, forKey: "title")
                objectToUpdate.setValue(newAuthor, forKey: "author")
                objectToUpdate.setValue(newSubName, forKey: "subjectName")
                objectToUpdate.setValue(newDueDate, forKey: "dueDate")
                do{
                    //Save the managed object context
                    try managedContext.save()
                }
                catch let error as NSError {
                    print("Could not update the record! \(error), \(error.userInfo)")
                }
            }
            catch let error as NSError {
                print("Could not find the record to update! \(error), \(error.userInfo)")
            }
        }
    }
    
    
    static func deleteAll() {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                let managedContext = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksList")

                do {
                    let records = try managedContext.fetch(fetchRequest)
                    for case let record as NSManagedObject in records {
                        managedContext.delete(record)
                    }

                    try managedContext.save()
                } catch let error as NSError {
                    print("Could not delete all records! \(error), \(error.userInfo)")
                }
            }
        }
    
    static func readAll() -> [[String: Any]] {
        var booksList = [[String: Any]]()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BooksList")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                for record in result as! [NSManagedObject] {
                    let title = record.value(forKey: "title") as! String
                    let author = record.value(forKey: "author") as! String
                    let subName = record.value(forKey: "subjectName") as! String
                    let dueDate = record.value(forKey: "dueDate") as! Date
                    
                    let bookData: [String: Any] = ["title": title, "author": author, "subjectName": subName, "dueDate": dueDate]
                    booksList.append(bookData)
                }
            } catch let error as NSError {
                print("Could not fetch records! \(error), \(error.userInfo)")
            }
        }
        return booksList
    }

}
