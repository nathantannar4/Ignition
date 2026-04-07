//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == OffsetViewEffect {

    /// A ``ViewEffect`` that moves the view between an offset
    public static var offset: OffsetViewEffect {
        OffsetViewEffect(offset: CGPoint(x: 24, y: 0))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(x: CGFloat) -> OffsetViewEffect {
        OffsetViewEffect(offset: CGPoint(x: x, y: 0))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(y: CGFloat) -> OffsetViewEffect {
        OffsetViewEffect(offset: CGPoint(x: 0, y: y))
    }

    /// A ``ViewEffect`` that moves the view between an offset
    public static func offset(_ offset: CGPoint) -> OffsetViewEffect {
        OffsetViewEffect(offset: offset)
    }
}

/// A ``ViewEffect`` that moves the view between an offset
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OffsetViewEffect: ViewEffect {

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
struct OffsetViewEffect_Previews: PreviewProvider {
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
