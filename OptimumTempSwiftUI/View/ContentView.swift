//
//  ContentView.swift
//  OptimumTempSwiftUI
//
//  Created by Kaung Zin Lin on 18.09.23.
//

import SwiftUI

struct ContentView: View {
    @State var minimum: Double = 50
    @State var maximum: Double = 50
    @State var globalTemp: Int = 30
    @State var showingAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var locationManager = LocationManager()
    @StateObject var weatherManager = WeatherKitManager()
    @State var calculatorBrain = CalculatorBrain()
    @State var networkManager = NetworkManager()
    @State private var isShowingAlert = false
    
    var body: some View {
        
        // networkManager.monitorNetwork()
        
        ZStack {
            Color(red: 0.13, green: 0.21, blue: 0.33).edgesIgnoringSafeArea(.all)
            VStack {
                
                Spacer()
                
                Text("OptimumTemp").font(.system(size: 40)).fontWeight(.bold).foregroundColor(Color.white)
                Text("Your Personalized Climate Control Companion").foregroundColor(.white)
            
                
                Spacer()
                
                Text("Minimum Value: \(String(format: "%.0f", minimum))°C").foregroundColor(.white)
                Slider(value: $minimum, in: 0...100).tint(Color.init(red: 0.31, green: 0.44, blue: 1.00))
            
                
                Text("Maximum Value: \(String(format: "%.0f", maximum))°C").foregroundColor(.white)
                Slider(value: $maximum, in: 0...100).tint(Color.init(red: 0.31, green: 0.44, blue: 1.00))
                
                Button(action: {
                    
                    if minimum == maximum {
                        alertTitle = "There was an error!"
                        alertMessage = "Minimum Temp and Maximum Temp mustn't be the Same!"
                        showingAlert.toggle()
 
                    } else {
                        isShowingAlert = true
                        if let temperature = weatherManager.temperature {
                            // print("Outside Temp: \(temperature)")
                            
                            let results = calculatorBrain.calculateOptimumTemperature(tempMin: minimum, tempMax: maximum, outsideTemp: temperature)
                            
                            // let resultsString = String(format: ".%0f", results)
                            
                            alertTitle = "Optimum Results"
                            alertMessage = "Optimum Temp: \(round(results))°C\nOutside Temp: \(temperature)°C"
                            showingAlert.toggle()
                            
                                        }
                                        
    
                                     else {
                                         alertTitle = "There was an error!"
                                         alertMessage = "Please turn on Cellular Data or Wi-Fi to get outside temp!"
                                         showingAlert.toggle()
                                        
                                    }
                    }
                    
                }, label: {
                    Text("Find the Optimum Temp")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal, 20)
                        .background(
                            (Color.init(red: 0.31, green: 0.44, blue: 1.00))
                                .cornerRadius(20)
                                .shadow(radius: 100)
                        )
                }).alert(isPresented: $showingAlert, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMessage))
                })
    
            }.padding()

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

