//
//  OrderActivityManager.swift
//  LiveActivitiesExample
//
//  Created by tigi KIM on 2022/09/16.
//

import Foundation
import ActivityKit

public enum OrderStatus: CaseIterable, Codable, Equatable {
    case received
    case progress
    case ready
    
    var image: String {
        switch self {
        case .received:
            return "basket.fill"
        case .progress:
            return "stove.fill"
        case .ready:
            return "takeoutbag.and.cup.and.straw.fill"
        }
    }
    
    var title: String {
        switch self {
        case .received:
            return "Order received"
        case .progress:
            return "Order in progress"
        case .ready:
            return "Ready"
        }
    }
    
    var subTitle: String {
        switch self {
        case .received:
            return "Your order has been received."
        case .progress:
            return "Your order is in progress."
        case .ready:
            return "Your order is ready, please pick it up."
        }
    }
}


struct OrderAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var status: OrderStatus = .received
    }
    
    var orderNumber: Int
    var orderItems: [String]
}


public class OrderActivityManager {
    private init() {}
    
    public static func status(id: String) -> OrderStatus? {
        guard let activity = Activity<OrderAttributes>.activities.first(where: { $0.id == id }) else {
            return nil
        }
        
        return activity.contentState.status
    }
    
    public static func endLiveActivity(id: String) {
        guard let activity = Activity<OrderAttributes>.activities.first(where: { $0.id == id }) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Task {
                await activity.end(using: activity.contentState, dismissalPolicy: .immediate)
            }
        }
    }
    
    public static func updateLiveActivity(id: String, updatedStatus: OrderStatus) {
        guard let activity = Activity<OrderAttributes>.activities.first(where: { $0.id == id }) else {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            var updatedState = activity.contentState
            updatedState.status = updatedStatus
            
            Task {
                await activity.update(using: updatedState)
            }
        }
    }
    
    public static func addLiveActivity() -> String? {
        let orderAttributes = OrderAttributes(orderNumber: 123, orderItems: ["cup.and.saucer.fill", "fork.knife.circle.fill"])
        let initialContentState = OrderAttributes.ContentState()
        
        do {
            let activity = try Activity<OrderAttributes>.request(attributes: orderAttributes,
                                                                 contentState: initialContentState,
                                                                 pushType: nil)
            
            print("Request a Live Activity \(String(describing: activity.id)).")
            
            return activity.id
        } catch {
            print(error.localizedDescription)
            
            return nil
        }
    }
}
