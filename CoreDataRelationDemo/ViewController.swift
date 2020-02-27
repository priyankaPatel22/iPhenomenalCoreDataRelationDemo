//
//  ViewController.swift
//  CoreDataRelationDemo
//
//  Created by Phycom  on 2/28/20.
//  Copyright © 2020 test. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Person> = {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()

        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]

        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.appDelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)

        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        addPersionData()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        let employeeData = fetchedResultsController.fetchedObjects
        print (employeeData!.count)
        
//        for i  in 0 ..< employeeData!.count{
//            let employee = fetchedResultsController.object(at: i)
//            print(employee.firstName)
//            print(employee.lastName)
//            print("")
//        }
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        let context = AppDelegate.appDelegate.persistentContainer.viewContext
        
        do {
            let result = try context.fetch(fetchrequest)
            for data in result as! [NSManagedObject]{
                print(data.value(forKey: "firstName") as! String)
                print(data.value(forKey: "address")!)
                
                let result1 = data.value(forKey: "address") as! NSSet
                var nsarr = result1.allObjects as NSArray
                
                for data1 in nsarr as! [NSManagedObject]{
                    print(data1.value(forKey: "city") as! String)
                }
                
//                for i in 0..<result1.count {
//                    let data1 = result1.in
//                    print(data1.value(forKey: "city") as! String)
//                }
                
               // print(data)
            }
            //print(result)
        } catch{
            print("fail")
        }
    }

    func addPersionData() {
        let context = AppDelegate.appDelegate.persistentContainer.viewContext
        
        let person = Person(context: context)
        
        person.firstName = "Bart"
        person.lastName = "Jacobs"
        
        let address = Address(context: context)
        
        address.city = "Boston"
        address.street = "Main Street"
        
        //newPerson.setValue(NSSet(object: newAddress), forKey: "addresses")
        
        person.address = NSSet(object: address)
        
        do {
            try context.save()
            //navigationController?.popViewController(animated: true)
            
        } catch {
            print("Failed saving")
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {}
