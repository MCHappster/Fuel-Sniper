//
//  ContentView.swift
//  Fuel Sniper
//
//  Created by Ethan Colgan on 24/11/21.
//

//  We can create other views but we get this main file to begin with. This file is linked to using the ContentView() function in the Fuel_SniperApp.swift file.

import SwiftUI

struct Fuel {
    let price: Double
}

private func getFuelPrices() -> [Fuel] { //Function that returns array of random prices (testing)
    var fuelPrices = [Fuel]() //Declare variable
    
    for _ in 1...20 {
            let fuel_cost = Fuel(price: Double.random(in: 100...200)) //Random int between 100-200
            fuelPrices.append(fuel_cost) //Append price to array
    }
    return fuelPrices
}

private func getTimeLabels() -> [String] {
    return (2015...2021).map {
        String($0)
    }
}

struct ContentView: View {
    @State var circleProgress: CGFloat = 0.3
    @State var avgPrice: CGFloat = 40.26
    @State private var selectedFuelType = "Unleaded 95"
    // animation value
    @State private var animationAmount: CGFloat = 0
    
    var primaryColor = Color(red: 0 / 255, green: 100 / 255, blue: 156 / 255)
    var ratings = ["Bad", "Average", "Good"]
    let fuelTypes = ["Unleaded 95", "Unleaded 91", "Deisel"]

    var body: some View {
        VStack {
            // top panel
            VStack {
                // top info
                HStack {
                    Spacer()
                    // fuel picker
                    Picker("Select a fuel type", selection: $selectedFuelType) {
                        ForEach(fuelTypes, id: \.self) {
                            Text($0)
                        }
                    }
                
                    .pickerStyle(.menu)
                    Spacer()
                    // City
                    Text("ADELAIDE")
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(primaryColor))
            .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
            
            //The guage and reading of avg city price
            ZStack()
            {
                //grey background circle
                Circle()
                    .trim(from: 0.0, to: 1 / 4*3)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color(UIColor.white))
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: -225))
                   
                //guage circle
                Circle()
                    .trim(from: 0.0, to: animationAmount*(circleProgress / 4*3))
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .foregroundColor(Color(UIColor(hue: CGFloat(circleProgress) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0)))
                
                    .frame(width: 150, height: 150)
                    .rotationEffect(Angle(degrees: -225))
                    
                
                //average price text
                Text("\(Int(self.avgPrice))")
                    .font(.custom("HelveticaNeue", size: 40.0))
            }
            .padding(.top, 100)
        
            //rating based on circle progress
            if circleProgress == 0
            {
                Text(ratings[0])
            }
            else
            {
                Text(ratings[Int(ceil(circleProgress*3))-1])
            }
            
            
            //Divider()
            
            let prices = getFuelPrices().map { Int($0.price) } //Prices array
            let labels = getTimeLabels() //Labels array
            
            LineChartView(values: prices, labels: labels) //Display graph by calling function
            
            Spacer() //Space after the graph
        }
        
        .background(Color.green)
            .edgesIgnoringSafeArea(.all)
            .onAppear
            {
                //appear animation animationamount is CGFloat 0-1
                withAnimation(Animation.easeOut(duration: 1))
                {
                    animationAmount = 1
                }
            }
            .onDisappear {
                animationAmount = 0
            }
    
            Spacer()
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
