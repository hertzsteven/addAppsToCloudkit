//
//  CategoryPickerview.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/19/23.
//

import SwiftUI


struct CategoryPickerview: View {
    
    let fruits = ["Apple", "Banana", "Orange"]
    @State private var selectedFruitIndex = 0
    @State private var selectedFruit = ""
    
    var body: some View {
        VStack {
            Picker("Select a fruit", selection: $selectedFruitIndex) {
                ForEach(0..<fruits.count) { index in
                    Text(fruits[index]).tag(index)
                }
            }
            .pickerStyle(.wheel)
            .padding()
            
            TextField("Selected fruit: \(fruits[selectedFruitIndex])", text: $selectedFruit)
                .padding()
                .disabled(true)
        }
        .onChange(of: selectedFruitIndex) { newValue in
            selectedFruit = fruits[newValue]
        }
    }
}

struct CategoryPickerview_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerview()
    }
}

