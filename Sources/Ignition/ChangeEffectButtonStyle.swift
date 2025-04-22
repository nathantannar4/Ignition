//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension PrimitiveButtonStyle {

    /// A ``PrimitiveButtonStyle`` that runs a ``ViewEffect`` when pressed
    public static func changeEffect<Effect: ViewEffect>(
        effect: Effect
    ) -> ChangeEffectButtonStyle<Effect> where Self == ChangeEffectButtonStyle<Effect> {
        ChangeEffectButtonStyle(effect: effect)
    }

    /// A ``PrimitiveButtonStyle`` that runs a ``ViewEffect`` when pressed
    public static func changeEffect<Effect: ViewEffect>(
        effect: Effect,
        animation: Animation
    ) -> ChangeEffectButtonStyle<Effect> where Self == ChangeEffectButtonStyle<Effect> {
        ChangeEffectButtonStyle(effect: effect, animation: animation)
    }
}

/// A ``PrimitiveButtonStyle`` that runs a ``ViewEffect`` when pressed
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ChangeEffectButtonStyle<
    Effect: ViewEffect
>: PrimitiveButtonStyle {

    public var effect: Effect
    public var animation: ViewEffectAnimation

    @State private var trigger: UInt = 0

    @inlinable
    public init(
        effect: Effect,
        animation: Animation
    ) {
        self.effect = effect
        self.animation = .continuous(animation)
    }

    @inlinable
    public init(
        effect: Effect,
        animation: ViewEffectAnimation = .default
    ) {
        self.effect = effect
        self.animation = animation
    }

    public func makeBody(configuration: Configuration) -> some View {
        Button {
            trigger &+= 1
            configuration.trigger()
        } label: {
            configuration.label
        }
        .changeEffect(effect, value: trigger, animation: animation)
    }
}

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct ChangeEffectButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Button {

            } label: {
                Text("Run Effect")
            }
            .buttonStyle(
                .changeEffect(
                    effect: .background {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.blue, lineWidth: 2)
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.9),
                                    removal: .scale(scale: 2)
                                )
                                .combined(with: .opacity)
                            )
                    }
                )
            )

            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                Button {
                    
                } label: {
                    Text("Run Effect")
                }
                .buttonStyle(
                    .changeEffect(
                        effect: .background {
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.blue, lineWidth: 2)
                                .transition(
                                    .asymmetric(
                                        insertion: .scale(scale: 0.9),
                                        removal: .scale(scale: 2)
                                    )
                                    .combined(with: .opacity)
                                )
                        }
                    )
                )
                .buttonStyle(.bordered)
            }
        }
    }
}
