//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

/// The style for ``TransitionEffectModifier``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol TransitionEffectStyle: ViewStyle where Configuration == TransitionEffectConfiguration {
}

/// The configuration parameters for ``LabeledView``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public struct TransitionEffectConfiguration {

    /// A type-erased content of a ``TransitionEffectModifier``
    public struct Content: ViewAlias { }
    public var content: Content { .init() }

    /// An opaque identifier to the transaction of a triggered ``TransitionEffect``
    public struct ID: Hashable {
        var value: UInt
    }
    public var id: ID

    public var isActive: Bool
    public var progress: Double
}
