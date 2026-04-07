//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect {

    /// A ``ViewEffect`` that concatenates an additional ``ViewEffect``
    public func concat<ConcatenatingEffect: ViewEffect>(
        _ effect: ConcatenatingEffect
    ) -> ConcatenatedViewEffect<Self, ConcatenatingEffect> where Self: ViewEffect {
        ConcatenatedViewEffect(effect: self, concatenating: effect)
    }
}

/// A ``ViewEffect`` that concatenates an additional ``ViewEffect``
@frozen
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct ConcatenatedViewEffect<
    Effect: ViewEffect,
    ConcatenatingEffect: ViewEffect
>: ViewEffect {

    public let effect: Effect
    public let concatenatingEffect: ConcatenatingEffect

    public init(
        effect: Effect,
        concatenating concatenatingEffect: ConcatenatingEffect
    ) {
        self.effect = effect
        self.concatenatingEffect = concatenatingEffect
    }
    
    public func makeBody(configuration: Configuration) -> some View {
        effect.makeBody(configuration: configuration)
            .modifier(
                ViewEffectModifier(
                    effect: concatenatingEffect,
                    configuration: configuration
                )
            )
    }
}

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct ConcatenatedViewEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Hello, World")
                .scheduledEffect(
                    .offset.concat(.scale),
                    interval: 1
                )

            Text("Hello, World")
                .scheduledEffect(
                    .offset(y: 20).concat(.scale(scale: 2)),
                    interval: 1
                )
        }
    }
}
