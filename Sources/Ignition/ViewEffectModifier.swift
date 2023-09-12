//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

/// A modifier that applies a `ViewEffect`
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ViewEffectModifier<
    Effect: ViewEffect
>: ViewModifier {

    public var effect: Effect
    public var configuration: Effect.Configuration

    @inlinable
    public init(
        effect: Effect,
        configuration: Effect.Configuration
    ) {
        self.effect = effect
        self.configuration = configuration
    }

    public func body(content: Content) -> some View {
        effect
            .makeBody(configuration: configuration)
            .viewAlias(ViewEffectConfiguration.Content.self) {
                content
            }
    }
}
