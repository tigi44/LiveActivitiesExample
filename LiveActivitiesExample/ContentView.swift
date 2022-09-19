//
//  ContentView.swift
//  LiveActivitiesExample
//
//  Created by tigi KIM on 2022/09/16.
//

import SwiftUI
import ActivityKit

struct ContentView: View {
    
    @State var currentActivityID: String = ""
    @State var currentActivityStatus: OrderStatus = .ordered
    @State var activityIDs: [String] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Add") {
                    Button("Request a new Live Activity") {
                        guard let currentActivityID = OrderActivityManager.addLiveActivity() else {
                            return
                        }
                        
                        self.currentActivityID = currentActivityID
                        self.activityIDs.append(currentActivityID)
                    }
                }
                
                if activityIDs.count > 0 {
                    Section("Select a Live Activity") {
                        Picker(selection: $currentActivityID) {
                            ForEach(activityIDs, id: \.self) { id in
                                Text(id)
                                    .tag(id)
                            }
                        } label: {
                        }
                        .pickerStyle(.wheel)
                    }
                    
                    Section("Change status") {
                        Picker(selection: $currentActivityStatus) {
                            Text("Ordered")
                                .tag(OrderStatus.ordered)
                            
                            Text("Progress")
                                .tag(OrderStatus.progress)
                            
                            Text("Complete")
                                .tag(OrderStatus.complete)
                        } label: {
                        }
                        .pickerStyle(.segmented)
                        .disabled(currentActivityID.count <= 0)
                    }
                    
                    Section("Remove") {
                        Button("End the Live Activity") {
                            guard currentActivityID.count > 0 else {
                                return
                            }
                            
                            OrderActivityManager.endLiveActivity(id: currentActivityID)
                            
                            self.activityIDs.removeAll(where: { $0 == currentActivityID})
                            currentActivityID = activityIDs.first ?? ""
                            if currentActivityID.count <= 0 {
                                currentActivityStatus = .ordered
                            }
                        }
                    }
                }
            }
            .navigationTitle("Live Activities")
            .onChange(of: currentActivityID, perform: { newValue in
                guard let currentActivityStatus = OrderActivityManager.status(id: newValue) else {
                    return
                }
                
                self.currentActivityStatus = currentActivityStatus
            })
            .onChange(of: currentActivityStatus) { newValue in
                OrderActivityManager.updateLiveActivity(id: currentActivityID, updatedStatus: newValue)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentActivityID: "test activity id", activityIDs: ["test activity id"])
    }
}
