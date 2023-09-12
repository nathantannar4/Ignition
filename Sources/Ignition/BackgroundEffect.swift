//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect {

    /// A ``ViewEffect`` that emits a view in the background
    public static func background<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Content
    ) -> BackgroundEffect<Content> where Self == BackgroundEffect<Content> {
        BackgroundEffect(
            alignment: alignment,
            content: content()
        )
    }
}

/// A ``ViewEffect`` that emits a view in the background
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct BackgroundEffect<Content: View>: ViewEffect {

    public var alignment: Alignment
    public var content: Content

    @inlinable
    public init(
        alignment: Alignment,
        content: Content
    ) {
        self.alignment = alignment
        self.content = content
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .background(
                ViewAdapter {
                    if configuration.isActive {
                        content
                            .id(configuration.id)
                    }
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            )
    }
}
