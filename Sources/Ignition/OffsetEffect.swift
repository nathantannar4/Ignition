//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == OffsetEffect {

    /// A ``ViewEffect`` that moves the view between an offset
    public static var offset: OffsetEffect {
        OffsetEffect(offset: CGPoint(x: 24, y: 0))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(x: CGFloat) -> OffsetEffect {
        OffsetEffect(offset: CGPoint(x: x, y: 0))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(y: CGFloat) -> OffsetEffect {
        OffsetEffect(offset: CGPoint(x: 0, y: y))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(offset: CGPoint) -> OffsetEffect {
        OffsetEffect(offset: offset)
    }
}

/// A ``ViewEffect`` that moves the view between an offset
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OffsetEffect: ViewEffect {

    public var offset: CGPoint

    @inlinable
    public init(offset: CGPoint) {
        self.offset = offset
    }

    public func makeBody(configuration: Configuration) -> some View {
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

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct OffsetEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Hello, World")
                .scheduledEffect(
                    .offset,
                    interval: 1
                )

            Text("Hello, World")
                .scheduledEffect(
                    .offset(y: 20),
                    interval: 1
                )
        }
    }
}
