//
//  VehicleDetailViewController.swift
//  iDealer
//
//  Created by IRS on 18/01/2018.
//  Copyright © 2018 IrsSoftware. All rights reserved.
//

import UIKit

class VehicleDetailViewController: UIViewController {

    @IBOutlet weak var labelVehicleDetail: UILabel!;
    /*
    var detailVehicle: Vehicles? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
     */
    var detailVehicle:Vehicles?;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.configureView();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView()
    {
        if let vehicle = detailVehicle {
            title = vehicle.vehicleTitle;
            self.labelVehicleDetail?.text = vehicle.vehicleDetailString;
        }
    }
    
    @IBAction func btnClickGoForward(_ sender: Any) {
        if let vehicle = detailVehicle
        {
            let controller = UIAlertController.alertControllerWithTitle(title: "Go Forward", message: vehicle.goForward());
            present(controller, animated: false, completion: nil);
        }
    }
    
    @IBAction func btnClickGoBackward(_ sender: Any) {
        if let vehicle = detailVehicle
        {
            let controller = UIAlertController.alertControllerWithTitle(title: "Go Backward", message: vehicle.goBackWard());
            present(controller, animated: false, completion: nil);
        }
    }
    
    
    @IBAction func btnClickTurn(_ sender: Any) {
        if let vehicle = detailVehicle
        {
            let controller = UIAlertController.alertControllerWithNumberInput(title: "turn", message: "Enter number of degrees to turn:", buttonTitle: "Go", handler: { intergerValue in
                if let value = intergerValue
                {
                    let controller = UIAlertController.alertControllerWithTitle(title: "Turn", message: vehicle.turn(degrees: value));
                    self.present(controller, animated: false, completion: nil);
                }
            })
            present(controller, animated: false, completion: nil);
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
