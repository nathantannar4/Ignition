//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect {

    /// A ``ViewEffect`` that emits a view in the foreground
    public static func overlay<Content: View>(
        alignment: Alignment = .center,
        content: Content
    ) -> OverlayEffect<Content> where Self == OverlayEffect<Content> {
        OverlayEffect(
            alignment: alignment,
            content: content
        )
    }

    /// A ``ViewEffect`` that emits a view in the foreground
    public static func overlay<Content: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ content: () -> Content
    ) -> OverlayEffect<Content> where Self == OverlayEffect<Content> {
        OverlayEffect(
            alignment: alignment,
            content: content()
        )
    }
}

/// A ``ViewEffect`` that emits a view in the foreground
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OverlayEffect<Content: View>: ViewEffect {

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
            .overlay(
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

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct OverlayEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Hello, World")
                .scheduledEffect(
                    .overlay {
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .padding(-2)
                    },
                    interval: 1
                )

            Text("Hello, World")
                .scheduledEffect(
                    .overlay {
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .padding(-2)
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.5),
                                    removal: .scale(scale: 2)
                                )
                                .combined(with: .opacity)
                            )
                    },
                    interval: 1
                )
        }
    }
}
