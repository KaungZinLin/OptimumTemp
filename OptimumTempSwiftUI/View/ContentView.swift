//
//  ContentView.swift
//  OptimumTempSwiftUI
//
//  Created by Kaung Zin Lin on 18.09.23.
//

import SwiftUI
import AlertKit

struct ContentView: View {
    @State var minimum: Double = 50
    @State var maximum: Double = 50
    @State var globalTemp: Int = 30
    @State var showingAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var backgroundGradient1 = Color.teal
    @State var backgroundGradient2 = Color.blue
    @State var backgroundGradientforButton1 = Color.teal
    @State var backgroundGradientforButton2 = Color.blue
    @State var showAlert = false
    @Environment(\.colorScheme) var colorScheme
    @State private var modeString = "Light Mode"
    @State var locationManager = LocationManager()
    @StateObject var weatherManager = WeatherKitManager()
    @State var calculatorBrain = CalculatorBrain()
    @State var networkManager = NetworkManager()
    @State private var isShowingAlert = false
    
    var body: some View {
        
        ZStack {
            VStack {
                
                Spacer()
                
                Text("OptimumTemp").font(.system(size: 40)).fontWeight(.bold).foregroundColor(Color.white)
                Text("Your Private Climate Control Companion").foregroundColor(.white)
                
                
                Spacer()
                
                let minimumInF = minimum * 9/5 + 32
                let maximumInF = maximum * 9/5 + 32
                
                Text("Minimum Temperature: \(String(format: "%.0f", minimum))°C / \(String(format: "%.0f", minimumInF)) °F").foregroundColor(.white)
                Slider(value: $minimum, in: 0...100).tint(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                
                
                Text("Maximum Temperature: \(String(format: "%.0f", maximum))°C / \(String(format: "%.0f", maximumInF))°F").foregroundColor(.white)
                Slider(value: $maximum, in: 0...100).tint(LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing))
                
                Button(action: {
                    
                    if colorScheme == .dark {
                        backgroundGradient1 = Color.black
                        backgroundGradient2 = Color.teal
                        backgroundGradientforButton1 = Color.teal
                        backgroundGradientforButton1 = Color.black
                    } else {
                        backgroundGradient1 = Color.teal
                        backgroundGradient2 = Color.blue
                        backgroundGradientforButton1 = Color.teal
                        backgroundGradientforButton1 = Color.blue
                    }
                    
                    if minimum == maximum {
                        alertTitle = "There was an error!"
                        alertMessage = "Minimum and maximum temps must differ."
                        // showingAlert.toggle()
                        
                        AlertKitAPI.present(
                            title: alertMessage,
                            icon: .error,
                            style: .iOS17AppleMusic,
                            haptic: .error
                            
                            
                        )
                        
                    } else if minimum > maximum || maximum < minimum {
                        alertMessage = "Minimum temp mustn't exceed maximum temp."
                        AlertKitAPI.present(
                            title: alertMessage,
                            icon: .error,
                            style: .iOS17AppleMusic,
                            haptic: .error
                        )
                    } else {
                        isShowingAlert = true
                        if let temperature = weatherManager.temperature {
                            // print("Outside Temp: \(temperature)")
                            
                            let results = calculatorBrain.calculateOptimumTemperature(tempMin: minimum, tempMax: maximum, outsideTemp: temperature)
                            
                            // let resultsString = String(format: ".%0f", results)
                            
                            let temperatureInF = temperature * 9/5 + 32
                            let resultsInF = results * 9/5 + 32
                            
                            
                            
                            alertTitle = "Optimum Results"
                            alertMessage = "Optimum Temp: \(String(format: "%.0f", results))°C / \(String(format: "%.0f", resultsInF))°F \nOutside Temp: \(temperature)°C / \(String(format: "%.0f", temperatureInF))°F"
                            // showingAlert.toggle()
                            
                            AlertKitAPI.present(
                                title: alertMessage,
                                icon: .done,
                                style: .iOS17AppleMusic,
                                haptic: .success
                                
                                
                            )
                            
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
                        .background(LinearGradient(gradient: Gradient(colors: [backgroundGradientforButton1, backgroundGradient2]), startPoint: .leading, endPoint: .trailing)
                            .cornerRadius(20)
                            .shadow(radius: 100)
                        )
                }).alert(isPresented: $showingAlert, content: {
                    Alert(title: Text(alertTitle), message: Text(alertMessage))
                })
                
                Button("Find Human Acceptable Temperature") {
                    
                   
                    
                    if colorScheme == .dark {
                        backgroundGradient1 = Color.black
                        backgroundGradient2 = Color.teal
                        backgroundGradientforButton1 = Color.teal
                        backgroundGradientforButton1 = Color.black
                    } else {
                        backgroundGradient1 = Color.teal
                        backgroundGradient2 = Color.blue
                        backgroundGradientforButton1 = Color.teal
                        backgroundGradientforButton1 = Color.blue
                    }
                    
                    alertTitle = "The Human Acceptable Temperature"
                    alertMessage = "The normal human body temperature is generally accepted to be around 98.6°F (37°C), but newer studies suggest that the average internal temperature for men and women is 36.4°C (97.5°F). The temperature can vary by age, activity, and time of day.1 Higher temperatures seem to provide an advantage in fighting infections and are part of the body's natural immune response.2 Most human pathogens reproduce best at temperatures below 98.6°F, and they have increasing troubles as the temperature in the body goes up. The average human body temperature in the United States has dropped since the 19th century, according to researchers at the Stanford University School of Medicine."
                    showingAlert.toggle()
                }.font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 20)
                    .background(LinearGradient(gradient: Gradient(colors: [backgroundGradientforButton1, backgroundGradient2]), startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(20)
                        .shadow(radius: 100))
                    .frame(width: 300)
                
            }.padding()
            
        }.background(LinearGradient(gradient: Gradient(colors: [backgroundGradient1, backgroundGradient2]), startPoint: .leading, endPoint: .trailing))
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}
