//
//  ContentView.swift
//  FoodPicker
//
//  Created by dreaMTank on 2024/06/04.
//

import SwiftUI


struct ContentView: View {
    
    let food = ["汉堡","沙拉","意大利面","火锅","关东煮"]
    @State private var selectedFood: String?
 
    var body: some View {
    
        VStack(spacing: 30) {
            Image("dinner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                
                

            Text("今天吃什么？")
                .font(.title)
                .bold()
            if selectedFood != .none{
                Text(selectedFood ?? "")
                    .font(.largeTitle)
                    .bold().foregroundColor(.green)
            }
            
            
            Button(role: .none, action: {
                selectedFood=food.shuffled().filter{ $0
                    != selectedFood}.first
                    
                
            }, label: {
                Text(selectedFood == .none ? "告诉我！" : "换一个").frame(width: 200)
            }).font(.title)
                .buttonStyle(.borderedProminent)
          
            Button(role: .none, action: {
                selectedFood = .none
                
            }, label: {
                Text("重置").frame(width: 200)
            }).font(.title)
                .buttonStyle(.bordered)
           
                
        }
        .padding()
        .animation(.easeInOut, value: selectedFood)
    }
}

#Preview {
    ContentView()
}
