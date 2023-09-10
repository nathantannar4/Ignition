//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension TransitionEffectStyle {

    /// A ``TransitionEffectStyle`` that emits a view
    public static func replicator<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> ReplicatorEffect<Content> where Self == ReplicatorEffect<Content> {
        ReplicatorEffect(
            content: content(),
            transition: .asymmetric(
                insertion: .scale(scale: 0.9),
                removal: .scale(scale: 1.5)
            )
            .combined(with: .opacity)
        )
    }

    /// A ``TransitionEffectStyle`` that emits a view
    public static func replicator<Content: View>(
        @ViewBuilder content: () -> Content,
        transition: AnyTransition
    ) -> ReplicatorEffect<Content> where Self == ReplicatorEffect<Content> {
        ReplicatorEffect(content: content(), transition: transition)
    }
}

/// A ``TransitionEffectStyle`` that emits a view
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ReplicatorEffect<Content: View>: TransitionEffectStyle {

    public var content: Content
    public var transition: AnyTransition

    @State var count = 0

    @inlinable
    public init(content: Content, transition: AnyTransition) {
        self.content = content
        self.transition = transition
    }

    public func makeBody(configuration: TransitionEffectConfiguration) -> some View {
        configuration.content
            .overlay(
                ViewAdapter {
                    if configuration.isActive {
                        content
                            .transition(transition)
                            .id(configuration.id)
                    }
                }
            )
    }
}
