//
//  VehiclesTableViewController.swift
//  iDealer
//
//  Created by IRS on 17/01/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit

class VehiclesTableViewController: UITableViewController {
    var vehiclesArray:[Vehicles] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad();
        setupVehicleArray();
        title = "Test Vehicle";
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVehicleArray(){
        /*
        vehiclesArray.removeAll(keepingCapacity: true);
        
        let mustang = Car(brandName: "Mustang", modelName: "Ford", modelYear: 1968, powerSource: "gas engine", isConvertible: true, isHatchback: false, hasSunroof: false, numberOfDoors: 2);
        
        vehiclesArray.append(mustang);
        
        let outback = Car(brandName: "Subaru", modelName: "Outback", modelYear: 1999, powerSource: "gas engine", isConvertible: false, isHatchback: true, hasSunroof: false, numberOfDoors: 5);
        
        vehiclesArray.append(outback);
        
        let harley = Motorcycle(brandName: "Harley-Davidsan", modelName: "SoftTail", modelYear: 1979, engineNoise: "Roooooooom");
        vehiclesArray.append(harley);
        
        let kawasaki = Motorcycle(brandName: "Kawasaki", modelName: "ninja", modelYear: 2005, engineNoise: "Neeeeeeeeeow");
        vehiclesArray.append(kawasaki);
        
        let silverado = Truck(brandName: "Chevelet", modelName: "Silverado", modelYear: 2011, powerSource: "Gas Engine", numberOfWheels: 4, cargoCapacityCubicFeet: 53);
        vehiclesArray.append(silverado);
        
        let monster = Truck(brandName: "PeterBill", modelName: "Monster 1", modelYear: 2018, powerSource: "Diesel", numberOfWheels: 10, cargoCapacityCubicFeet: 101);
        vehiclesArray.append(monster);
        */
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return vehiclesArray.count;
        return VehicleList.sharedInstance.vehicles.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style:UITableViewCellStyle.subtitle, reuseIdentifier: "Cell");
        //let vv = vehiclesArray[indexPath.row] as Vehicles;
        let vv = VehicleList.sharedInstance.vehicles[indexPath.row];
        print(vv);
        cell.textLabel?.text = vv.vehicleTitle;
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VehicleDetailViewController(nibName: "VehicleDetailViewController", bundle: Bundle.main);
        //let vehicle = vehiclesArray[indexPath.row];
        let vehicle = VehicleList.sharedInstance.vehicles[indexPath.row];
        vc.detailVehicle = vehicle;
        self.navigationController?.pushViewController(vc, animated: false);
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
