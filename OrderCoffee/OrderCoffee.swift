//
//  OrderCoffee.swift
//  OrderCoffee
//
//  Created by tigi KIM on 2022/09/16.
//

import WidgetKit
import SwiftUI
import Intents
import ActivityKit

@main
struct OrderCoffee: Widget {
    var body: some WidgetConfiguration {

        ActivityConfiguration(for: OrderAttributes.self) { context in
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("")
                }
            } compactLeading: {
                Text("")
            } compactTrailing: {
                Text("")
            } minimal: {
                Text("")
            }
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<OrderAttributes>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15,
                             style: .continuous)
            .fill(Color.black.gradient)
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("#\(context.attributes.orderNumber) \(context.state.status.title)")
                            .font(.title3)
                            .foregroundColor(.white)
                        Text(context.state.status.subTitle)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                    }

                    Spacer()
                    
                    HStack(spacing: -8) {
                        ForEach(context.attributes.orderItems, id: \.self) { item in
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .padding(-2)
                                
                                Circle()
                                    .stroke(.red, lineWidth: 1.5)
                                    .padding(-2)
                                
                                Image(systemName: item)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                            }
                            .frame(width: 40, height: 40)
                        }
                    }
                }
                
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                    gradient: Gradient(stops: [
                                        Gradient.Stop(color: context.state.status == .ordered ? .white.opacity(0.6) : .red, location: 0.5),
                                        Gradient.Stop(color: context.state.status == .complete ? .red : .white.opacity(0.6), location: 0.5)
                                    ]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                        )
                        .frame(height: 2)
                        .offset(y: 12)
                        .padding(.horizontal, 60)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    
                    HStack(alignment: .bottom, spacing: 0) {
                        ForEach(OrderStatus.allCases, id: \.self) { status in
                            Image(systemName: status.image)
                                .font(context.state.status == status ? .title2 : .body)
                                .foregroundColor(context.state.status == status ? .red : .white.opacity(0.6))
                                .frame(width: context.state.status == status ? 45 : 32, height: context.state.status == status ? 45 : 32)
                                .background {
                                    Circle()
                                        .fill(context.state.status == status ? .white : .red.opacity(0.4))
                                }
                                .background(alignment: .bottom, content: {
                                    BottomArrow(status: context.state.status, type: status)
                                })
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    func BottomArrow(status: OrderStatus, type: OrderStatus) -> some View {
        Image(systemName: "arrowtriangle.down.fill")
            .font(.system(size: 15))
            .scaleEffect(x: 1.3)
            .offset(y: 6)
            .opacity(status == type ? 1 : 0)
            .foregroundColor(.white)
            .overlay(alignment: .bottom) {
                Circle()
                    .fill(.white)
                    .frame(width: 5, height: 5)
                    .offset(y: 13)
            }
    }
}
