//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == RotationEffect {

    /// A ``ViewEffect`` that rotates the view by an angle
    public static var rotate: RotationEffect {
        RotationEffect(angle: .degrees(360), anchor: .center)
    }

    /// A ``ViewEffect`` that rotates the view by an angle
    public static func rotate(angle: Angle, anchor: UnitPoint = .center) -> RotationEffect {
        RotationEffect(angle: angle, anchor: anchor)
    }
}

/// A ``ViewEffect`` that rotates the view by an angle
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct RotationEffect: ViewEffect {

    public var angle: Angle
    public var anchor: UnitPoint

    @inlinable
    public init(angle: Angle, anchor: UnitPoint) {
        self.angle = angle
        self.anchor = anchor
    }

    public func makeBody(configuration: Configuration) -> some View {
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

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct RotationEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Hello, World")
                .scheduledEffect(
                    .rotate,
                    interval: 1
                )

            Text("Hello, World")
                .scheduledEffect(
                    .rotate(angle: .degrees(-180)),
                    interval: 1
                )
        }
    }
}
