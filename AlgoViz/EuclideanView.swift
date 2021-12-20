//
//  EuclideanView.swift
//  AlgoViz
//
//  Created by Vlad Gershun on 12/19/21.
//

import SwiftUI

struct EuclideanView: View {
    @State private var algorithm: GCDAlgorithm? = nil
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var temp = 1
    @FocusState private var focus: Focus?
    enum Focus: Hashable {
        case first
        case second
    }
    private var isValid: Bool {
        GCDAlgorithm.isValid(a: firstNumber, b: secondNumber)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Stepper(value: $firstNumber) {
                        TextField("First", value: $firstNumber, format: .number)
                            .numberKeyboard($focus, equals: .first)
                    }
                    
                    Stepper(value: $secondNumber) {
                        TextField("Second", value: $secondNumber, format: .number)
                            .numberKeyboard($focus, equals: .second)
                    }
                  
                    HStack {
                        Button(action: {
                            
                            algorithm = GCDAlgorithm(firstNumber, secondNumber)
                            temp += 1
                            focus = nil
                        }) {
                            HStack {
                                Spacer()
                                Text("Calculate")
                                Spacer()
                            }
                        }
                        .disabled(!isValid)
                        .buttonStyle(.borderless)
                        Divider()
                        Button(action: {
                            firstNumber = Int.random(in: 1...999999)
                            secondNumber = Int.random(in: 1...999999)
                            algorithm = GCDAlgorithm(firstNumber , secondNumber)
                            temp += 1
                            focus = nil
                        }) {
                            HStack {
                                Spacer()
                                Text("Random")
                                Spacer()
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                } header: {
                    Text("Enter Numbers")
                }
                
                if let algorithm = algorithm {
                    HStack {
                        Spacer()
                        VStack {
                            Text(algorithm.larger, format: .number)
                                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
                                .id(algorithm.larger)
                        }
                        Spacer()
                        Divider()
                        Spacer()
                        VStack {
                            Text(algorithm.smaller, format: .number)
                                .transition(.asymmetric(insertion: .move(edge: .top), removal: .move(edge: .bottom)))
                                .id(algorithm.smaller)
                        }
                        Spacer()
                    }
                    .task {
                        let counter = self.temp
                        var isDone = false
                        while !isDone && !Task.isCancelled {
                            withAnimation {
                                assert(counter == self.temp && !Task.isCancelled)
                                isDone = self.algorithm!.step()
                            }
                            try? await Task.sleep(nanoseconds: 1 * NSEC_PER_SEC)
                        }
                    }
                    .id("\(firstNumber)\(secondNumber)\(temp)")

                    if let result = algorithm.result {
                        Section {
                            HStack{
                                Spacer()
                                Text(result, format: .number)
                                    .transition(.slide)
                                Spacer()
                            }
                        } header: {
                            Text("GCD")
                        }
                        .listRowBackground(Color.green)

                    }
                }
            }
            .navigationTitle("Euclidean Algorithm")
        }
    }
}

extension View {
    func numberKeyboard<Value: Hashable>(_ focusState: FocusState<Value?>.Binding, equals activeFocusValue: Value) -> some View {
        self.keyboardType(.decimalPad)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                if focusState.wrappedValue == activeFocusValue {
                    Button("Done") {
                        focusState.wrappedValue = nil
                    }
                }
            }
            
        }
        .focused(focusState, equals: activeFocusValue)
    }
}

struct EuclideanView_Previews: PreviewProvider {
    static var previews: some View {
        EuclideanView()
    }
}

