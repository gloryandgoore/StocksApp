//
//  MyStocksTableViewController.swift
//  StocksApp
//
//  Created by Caseyann Goore on 2022-10-18.
//

import UIKit
import CoreData

class MyStocksTableViewController: UITableViewController {

    lazy var myFetchResultController : NSFetchedResultsController<MyStocks> = {
        
        let fetch : NSFetchRequest<MyStocks> = MyStocks.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataStack.shared.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
         ftc.delegate = self
         
        return ftc
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try? myFetchResultController.performFetch()
         
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return myFetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // numbers of rows = num of objects
        return myFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let item = myFetchResultController.object(at: indexPath)
      //will call the function and add name/ticker/price to cell
        cell.configureCell(item: item)
        
        
        // Configure the cell...

        return cell
    }
   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //allow delete
        if editingStyle == .delete {
            let obj = myFetchResultController.object(at: indexPath)
            CoreDataStack.shared.persistentContainer.viewContext.delete(obj)
            CoreDataStack.shared.saveContext()
        }
    }
     

     
    // MARK: - Navigation

    }
//save bring back to start screen
    @IBAction func unwindSave(segue: UIStoryboardSegue) {
        guard segue.identifier == "save" else {return }
        let sourceViewController = segue.source as! MyStocksTableViewController
        if let _ = sourceViewController.thisStock {
            CoreDataStack.shared.saveContext()
        }
    }
     
//delegate for control/modify the behavior of other objects
extension MyStocksTableViewController : NSFetchedResultsControllerDelegate {
    // These methods are called by the iOS runtime, in response to user interaction and/or changes in the data source
    
 //update table
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    // Updates wrapper end
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // Section update
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    
    // Row update
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    }
}

//search bar delegate
extension MyStocksTableViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var predicate : NSPredicate? = nil
        if !searchText.isEmpty {
            predicate = NSPredicate(format: "name CONTAINS[c] %@ ", searchText)
        }
        myFetchResultController.fetchRequest.predicate = predicate
        try? myFetchResultController.performFetch()
        tableView.reloadData()
        
    }
}
