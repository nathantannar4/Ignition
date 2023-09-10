//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension TransitionEffectStyle where Self == RotationEffect {

    /// A ``TransitionEffectStyle`` that rotates the view by an angle
    public static var rotate: RotationEffect {
        RotationEffect(angle: .degrees(360), anchor: .center)
    }

    /// A ``TransitionEffectStyle`` that rotates the view by an angle
    public static func scale(angle: Angle, anchor: UnitPoint = .center) -> RotationEffect {
        RotationEffect(angle: angle, anchor: anchor)
    }
}

/// A ``TransitionEffectStyle`` that rotates the view by an angle
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct RotationEffect: TransitionEffectStyle {

    public var angle: Angle
    public var anchor: UnitPoint

    @inlinable
    public init(angle: Angle, anchor: UnitPoint) {
        self.angle = angle
        self.anchor = anchor
    }

    public func makeBody(configuration: TransitionEffectConfiguration) -> some View {
        configuration.content
            .modifier(
                Effect(
                    angle: configuration.progress * angle.radians,
                    anchor: anchor
                )
                .ignoredByLayout()
            )
    }

    private struct Effect: GeometryEffect {
        var angle: CGFloat
        var anchor: UnitPoint

        func effectValue(size: CGSize) -> ProjectionTransform {
            let sin = sin(angle)
            let cos = cos(angle)
            let x = anchor.x * size.width
            let y = anchor.y * size.height
            return ProjectionTransform(
                CGAffineTransform(
                    cos,
                    sin,
                    -sin,
                    cos,
                    x - x * cos + y * sin,
                    y - x * sin - y * cos
                )
            )
        }
    }
}
