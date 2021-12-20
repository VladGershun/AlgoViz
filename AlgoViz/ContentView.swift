//
//  ContentView.swift
//  AlgoViz
//
//  Created by Vlad Gershun on 12/19/21.
//

import SwiftUI

struct HomeView: View {
    @State private var algorithm: GCDAlgorithm? = nil
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var temp = 1
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper("\(firstNumber)", value: $firstNumber)
                    Stepper("\(secondNumber)", value: $secondNumber)
                    HStack {
                        Spacer()
                        Button("Start") {
                            algorithm = GCDAlgorithm(firstNumber, secondNumber)
                            temp += 1
                        }
                        Spacer()
                    }
                    
                } header: {
                    Text("Enter Numbers")
                }
                if let algorithm = algorithm {
                    Section {
                        Text(algorithm.a, format: .number)
                        Text(algorithm.b, format: .number)
                        Text(algorithm.larger, format: .number)
                            .transition(.slide)
                            .id(algorithm.larger)
                        Text(algorithm.smaller, format: .number)
                            .id(algorithm.smaller)
                            .transition(.slide)
                        if let result = algorithm.result {
                            Text(result, format: .number)
                                .transition(.slide)
                        }
                    }
                    .task {
                        var isDone = false
                        while !isDone {
                            withAnimation {
                                isDone = self.algorithm!.step()
                            }
                            try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
                        }
                    }
                    .id("\(firstNumber)\(secondNumber)\(temp)")
                }
            }
            .navigationTitle("Euclidean Algorithm")
        }
        
        
        
//        .task {
//            while algorithm.step() == false {
//                try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
//            }
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

