//
//  ContentView.swift
//  Example
//
//  Created by Nathan Tannar on 2023-09-12.
//

import SwiftUI
import Ignition

struct ContentView: View {
    @State var counter: Int = 0
    @State var isEnabled = true

    var body: some View {
        VStack(spacing: 24) {
            HStack(spacing: 48) {
                VStack(spacing: 48) {
                    Text("Ignition")
                        .font(.title.bold())
                        .frame(height: 30, alignment: .center)

                    Text("Schedule Driven")
                        .foregroundColor(.secondary)
                        .font(.headline)
                        .frame(height: 50, alignment: .center)

                    VStack(spacing: 4) {
                        Text("Event Driven")
                            .foregroundColor(.secondary)
                            .font(.headline)

                        Button {
                            counter += 1
                        } label: {
                            Text("Run")
                                .bold()
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(height: 50, alignment: .center)
                }

                makeEffectPair(
                    name: "Offset",
                    shape: Circle(),
                    effect: .offset,
                    animation: .asymmetric(
                        insertion: .linear(duration: 0.05),
                        removal: .interpolatingSpring(stiffness: 200, damping: 4)
                    )
                )
                .foregroundColor(.blue)

                makeEffectPair(
                    name: "Rotate",
                    shape: Rectangle(),
                    effect: .rotate(angle: .degrees(10)),
                    animation: .asymmetric(
                        insertion: .linear(duration: 0.05),
                        removal: .interpolatingSpring(stiffness: 200, damping: 4)
                    )
                )
                .foregroundColor(.yellow)

                makeEffectPair(
                    name: "Scale",
                    shape: Circle(),
                    effect: .scale,
                    animation: .asymmetric(
                        insertion: .linear(duration: 0.05),
                        removal: .interpolatingSpring(stiffness: 200, damping: 4)
                    )
                )
                .foregroundColor(.green)

                makeEffectPair(
                    name: "Overlay",
                    shape: Circle(),
                    effect: .overlay {
                        Circle()
                            .stroke(lineWidth: 2)
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.9),
                                    removal: .scale(scale: 1.5)
                                )
                                .combined(with: .opacity)
                            )
                    },
                    animation: .asymmetric(
                        insertion: nil,
                        removal: .easeOut(duration: 1)
                    )
                )
                .foregroundColor(.red)
            }
        }
    }

    func makeEffectPair<
        _Shape: Shape,
        Effect: ViewEffect
    >(
        name: String,
        shape: _Shape,
        effect: Effect,
        animation: ViewEffectAnimation
    ) -> some View {
        VStack(spacing: 48) {
            Text(name)
                .font(.headline)
                .foregroundColor(.secondary)
                .frame(height: 30, alignment: .center)

            shape
                .frame(width: 50, height: 50)
                .scheduledEffect(
                    effect,
                    interval: 2,
                    animation: animation,
                    isEnabled: isEnabled
                )

            shape
                .frame(width: 50, height: 50)
                .changeEffect(
                    effect,
                    value: counter,
                    animation: animation,
                    isEnabled: isEnabled
                )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
