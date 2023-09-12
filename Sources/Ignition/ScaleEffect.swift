//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == ScaleEffect {

    /// A ``ViewEffect`` that scales a view between a size
    public static var scale: ScaleEffect {
        ScaleEffect(scale: CGSize(width: 1.25, height: 1.25), anchor: .center)
    }

    /// A ``ViewEffect`` that scales a view between a size
    public static func scale(width: CGFloat, anchor: UnitPoint = .center) -> ScaleEffect {
        ScaleEffect(scale: CGSize(width: width, height: 1.0), anchor: anchor)
    }

    /// A ``ViewEffect`` that scales a view between a size
    public static func scale(height: CGFloat, anchor: UnitPoint = .center) -> ScaleEffect {
        ScaleEffect(scale: CGSize(width: 1.0, height: height), anchor: anchor)
    }

    /// A ``ViewEffect`` that scales a view between a size
    public static func scale(scale: CGSize, anchor: UnitPoint = .center) -> ScaleEffect {
        ScaleEffect(scale: scale, anchor: anchor)
    }
}

/// A ``ViewEffect`` that scales a view between a size
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ScaleEffect: ViewEffect {

    public var scale: CGSize
    public var anchor: UnitPoint

    @inlinable
    public init(scale: CGSize, anchor: UnitPoint) {
        self.scale = scale
        self.anchor = anchor
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .modifier(
                Effect(
                    x: 1.0 + configuration.progress * (scale.width - 1.0),
                    y: 1.0 + configuration.progress * (scale.height - 1.0),
                    anchor: anchor
                )
                .ignoredByLayout()
            )
    }

    private struct Effect: GeometryEffect {
        var x: CGFloat
        var y: CGFloat
        var anchor: UnitPoint

        func effectValue(size: CGSize) -> ProjectionTransform {
            ProjectionTransform(
                CGAffineTransform(
                    scaleX: x,
                    y: y
                )
                .translatedBy(
                    x: (1 - x) * anchor.x * size.width,
                    y: (1 - y) * anchor.y * size.height
                )
            )
        }
    }
}
