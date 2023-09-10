//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension TransitionEffectStyle where Self == OffsetEffect {

    /// A ``TransitionEffectStyle`` that moves the view between an offset
    public static var offset: OffsetEffect {
        OffsetEffect(offset: CGPoint(x: 24, y: 0))
    }

    /// A ``TransitionEffectStyle`` that moves the view between an offset
    public static func offset(x: CGFloat) -> OffsetEffect {
        OffsetEffect(offset: CGPoint(x: x, y: 0))
    }

    /// A ``TransitionEffectStyle`` that moves the view between an offset
    public static func offset(y: CGFloat) -> OffsetEffect {
        OffsetEffect(offset: CGPoint(x: 0, y: y))
    }

    /// A ``TransitionEffectStyle`` that moves the view between an offset
    public static func offset(offset: CGPoint) -> OffsetEffect {
        OffsetEffect(offset: offset)
    }
}

/// A ``TransitionEffectStyle`` that moves the view between an offset
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OffsetEffect: TransitionEffectStyle {

    public var offset: CGPoint

    @inlinable
    public init(offset: CGPoint) {
        self.offset = offset
    }

    public func makeBody(configuration: TransitionEffectConfiguration) -> some View {
        configuration.content
            .modifier(
                Effect(
                    x: configuration.progress * offset.x,
                    y: configuration.progress * offset.y
                )
                .ignoredByLayout()
            )
    }

    private struct Effect: GeometryEffect {
        var x: CGFloat
        var y: CGFloat

        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(
                CGAffineTransform(
                    translationX: x,
                    y: y
                )
            )
        }
    }
}
