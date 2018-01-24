//
//  ViewController.swift
//  EatMoreVegetables
//
//  Created by Alugbin LordRahl Abiodun Olutola on 19/01/2018.
//  Copyright © 2018 Alugbin LordRahl Abiodun Olutola. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var foodItems=[Food]()
    var moc:NSManagedObjectContext!
    
    let appDelegate=UIApplication.shared.delegate as? AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //we initialixed the NSManagedObject Context
        moc=appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource=self
        
        loadData()
    }
    
    //===========TABLEVIEW DATASOURCE PROTOCOL IMPLEMENTATION
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //we create a cell
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //we get the single food item from each row.
        let foodItem=foodItems[indexPath.row]
        
        //we set the attribute to a constant
        let foodType=foodItem.foodType
        
        
        //the constant is assigned to the textlabel...
        cell.textLabel?.text=foodType
        
        
        //The Date Item is retrieved from the storage and casted to date
        let foodDate=foodItem.added! as Date
        
        //a dateformatter is created
        let dateFormatter=DateFormatter()
        
        //The dateformat is passed to the dateformatter
        dateFormatter.dateFormat="MMMM d yyyy, hh:mm"
        
        //The date is added to the subtitle
        cell.detailTextLabel?.text=dateFormatter.string(from: foodDate)
        
        
        //lets proceed to set the image
        //This allows the rght image to be set for each entity
        if foodType=="Fruit"{
            cell.imageView?.image=UIImage(named: "Apple")
        }
        else{
            cell.imageView?.image=UIImage(named: "Salad")
        }
        
        return cell
        
    }
    
    //===========END TABLEVIEW DATASOURCE PROTOCOL IMPLEMENTATION
    

    @IBAction func addFruitToDatabase(_ sender: UIButton) {
        let foodItem=Food(context:moc)
        foodItem.added=NSDate()
        
        //This checks where the request is coming from and adds
        //the correct type of food to the foodItem context.
        if(sender.tag==0){
            foodItem.foodType="Fruit"
        }else{
            foodItem.foodType="Vegetable"
        }
        
        //this saves the supplied item
        appDelegate?.saveContext()
        
        //this refereshes the data on the table
        loadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let foodRequest:NSFetchRequest<Food>=Food.fetchRequest()
        let sortDescriptor=NSSortDescriptor(key: "added", ascending: true)
        
        foodRequest.sortDescriptors=[sortDescriptor]
        
        do{
            try foodItems=moc.fetch(foodRequest)
        }
        catch{
            print("Could not load Data comfortably.")
        }
        
        self.tableView.reloadData()
    }


}

