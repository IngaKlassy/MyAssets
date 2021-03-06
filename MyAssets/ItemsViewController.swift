//
//  ItemsViewController.swift
//  MyAssets
//
//  Created by Inga Klassy on 10/2/18.
//  Copyright © 2018 Inga Klassy. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    
    
    // MARK: - Initializers
    //set the left bar button item (Edit)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    
    // MARK: - View life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    
    // MARK: - Actions
    @IBAction func addNewItem(sender: AnyObject) {
        //create a new item and add it to the store
        let newItem = itemStore.createItem()
        
        //figure out where that item is in array
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            //insert this new row into the table
            tableView.insertRows(at: [indexPath as IndexPath], with: .automatic)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the triggered segue is the "ShowItem" segue
        if segue.identifier == "ShowItem" {
            //figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                //get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }
    
    
    
    // MARK: - UITableViewDataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection didSelectRowInSection: Int) -> Int {
        return itemStore.allItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        //update the labels for the new prefered text size
        cell.updateLabels()
        //set the text on the cell with the description of the item that is at the nth index of items,
        //where n = row this cell will appear in on the tableview
        let item = itemStore.allItems[indexPath.row]
        
        //configure the cell with the item
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //if the table view is asking to commit a delete command
        if editingStyle == .delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
                //remove the item from the store
                self.itemStore.removeItem(item: item)
                
                //remove the item's image from the image store
                self.imageStore.deleteImageForKey(key: item.itemKey)
                
                //also remove that row from the table view with an animation
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            ac.addAction(deleteAction)
            
            //present the alert controller
            present(ac, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //update the model
        itemStore.moveItemAtIndex(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
}















