//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

/// The style for ``ViewEffectModifier``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public protocol ViewEffect: DynamicProperty {

    associatedtype Body: View
    @MainActor @ViewBuilder func makeBody(configuration: Configuration) -> Body

    typealias Configuration = ViewEffectConfiguration
}

/// The configuration parameters for ``ViewEffect``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ViewEffectConfiguration {

    /// A type-erased content of a ``ViewEffectModifier``
    public struct Content: ViewAlias { }
    public var content: Content { .init() }

    /// An opaque identifier to the transaction of a triggered ``ViewEffect``
    public struct ID: Hashable {
        var value: UInt
    }
    public var id: ID

    public var isActive: Bool
    public var progress: Double
}
