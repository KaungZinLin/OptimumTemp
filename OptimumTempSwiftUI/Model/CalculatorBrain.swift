//
//  CalculatorBrain.swift
//  OptimumTempSwiftUI
//
//  Created by Kaung Zin Lin on 19.09.23.
//

import Foundation
import SwiftUI

struct CalculatorBrain {
    
    func calculateOptimumTemperature(tempMin: Double, tempMax: Double, outsideTemp: Double) -> Double {
        let weightedAverage = Double(tempMin + tempMax + outsideTemp) / 3
        
        print("Optimum Temp: \(weightedAverage)")
        return weightedAverage
        
    }

    
}
