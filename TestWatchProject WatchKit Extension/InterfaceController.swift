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
    
    var mealCost: Float?
    var tipPercent: Float = 15.0
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
//        tipSlider.setValue(tipPercent)
//        updateFinalCost()
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
                    newPrice = "0.00"
                }
                else {
                    newPrice = newPrice?.replacingOccurrences(of: "$", with: "")
                }
                self.mealCost = Float(newPrice!)
                if (self.mealCost != nil) {
                    self.amountButton.setTitle("Bill $ " + String(format: "%.2f", self.mealCost!))
                }
                self.updateFinalCost()
        })
    }
    
    @IBAction func sliderChanged(_ value: Float) {
        tipPercent = value
        tipLabel.setText( "with \(Int(tipPercent))% tip")
        updateFinalCost()
    }
    
    func updateFinalCost() {
        guard mealCost != nil else {
            totalLabel.setText("$ 0.00")
            amountButton.setTitle("Enter Bill Amount")
            return
        }
        
        totalLabel.setText("$ " + String(format: "%.2f", finalCost()))
    }
    
    func finalCost() -> Float {
        return mealCost! + tipPercent / 100.0 * mealCost!
    }
    
}
