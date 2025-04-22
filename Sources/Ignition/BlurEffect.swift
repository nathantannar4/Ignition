//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == BlurEffect {

    /// A ``ViewEffect`` that applies a blur to the view
    public static func blur(
        radius: Double,
        opaque: Bool = false
    ) -> BlurEffect {
        BlurEffect(radius: radius, opaque: opaque)
    }
}

/// A ``ViewEffect`` that applies a blur to the view
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct BlurEffect: ViewEffect {

    public var radius: Double
    public var opaque: Bool = false

    @inlinable
    public init(radius: Double, opaque: Bool = false) {
        self.radius = radius
        self.opaque = opaque
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .blur(radius: configuration.isActive ? radius : 0, opaque: opaque)
    }
}

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct BlurEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            Text("Hello, World")
                .scheduledEffect(
                    .blur(radius: 5),
                    interval: 1
                )

            Text("Hello, World")
                .scheduledEffect(
                    .blur(radius: 20),
                    interval: 1
                )
        }
    }
}
