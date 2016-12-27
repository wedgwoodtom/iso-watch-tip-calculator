//
//  InterfaceController.swift
//  TestWatchProject WatchKit Extension
//
//  Created by Tom on 12/23/16.
//  Copyright © 2016 Tom Patterson. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var amountButton: WKInterfaceButton!
    
    @IBOutlet var tipSlider: WKInterfaceSlider!
    
    @IBOutlet var totalLabel: WKInterfaceLabel!
    
    @IBOutlet var tipLabel: WKInterfaceLabel!
    
    @IBOutlet var patronsLabel: WKInterfaceLabel!
    
    @IBOutlet var costBreakdownLabel: WKInterfaceLabel!
    
    var mealCost: Float?
    var tipPercent: Float = 15.0
    var patrons: Float = 1.0
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func btnClicked() {
        var newPrice:String?
        
        presentTextInputController(withSuggestions: ["Be Generous"], allowedInputMode: .plain,
            completion: { (price) -> Void in
                if (price != nil) {
                    newPrice = price?[0] as? String
                }
                if (newPrice == nil) {
                    newPrice = "N"
                }
                else {
                    newPrice = newPrice?.replacingOccurrences(of: "$", with: "")
                }
                self.mealCost = Float(newPrice!)
                if (self.mealCost != nil) {
                    self.amountButton.setTitle("Bill = $" + String(format: "%.2f", self.mealCost!))
                }
                self.updateFinalCost()
        })
    }
    
    @IBAction func sliderChanged(_ value: Float) {
        tipPercent = value
        tipLabel.setText( "\(Int(tipPercent))% tip")
        updateFinalCost()
    }
    
    @IBAction func patronsSliderChanged(_ value: Float) {
        let patronsInt = Int(value)
        
        if (patronsInt > 0) {
            patrons = value
            updateFinalCost()
        }
    }
    
    func updateFinalCost() {
        guard mealCost != nil else {
            totalLabel.setText("$ 0.00")
            amountButton.setTitle("Enter Bill Amount")
            costBreakdownLabel.setText("")
            return
        }
    
        let numPatrons = Int(patrons)
        let totalTip = tipPercent / 100.0 * mealCost! + 0.004
        let totalCost =  mealCost! + totalTip
        let totalCostPerPatron = totalCost / patrons
        let mealCostPerPatron = mealCost! / patrons
        let tipPerPatron = totalTip / patrons
        
        tipLabel.setText( "\(Int(tipPercent))% tip = $\(String(format: "%.2f", totalTip))")
        
        patronsLabel.setText("\(numPatrons) " + (numPatrons > 1 ? " split $\(String(format: "%.2f", totalCost )) for" : "Person"))

        
        totalLabel.setText("$ " + String(format: "%.2f", totalCostPerPatron) + (numPatrons > 1 ? " each" : ""))
        
        costBreakdownLabel.setHidden(numPatrons == 1)
        
        costBreakdownLabel.setText(
            "$" + String(format: "%.2f", mealCostPerPatron )
                + " + "
                + "$" + String(format: "%.2f", tipPerPatron) + " tip")
    }
    

}
