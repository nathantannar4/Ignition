//
// Copyright (c) Nathan Tannar
//

import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewEffect where Self == OpacityEffect {

    /// A ``ViewEffect`` that applies an opacity to the view
    public static var opacity: OpacityEffect {
        OpacityEffect(opacity: 0)
    }

    /// A ``ViewEffect`` that applies an opacity to the view
    public static func opacity(_ opacity: Double) -> OpacityEffect {
        OpacityEffect(opacity: opacity)
    }
}

/// A ``ViewEffect`` that applies an opacity to the view
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OpacityEffect: ViewEffect {

    public var opacity: Double

    @inlinable
    public init(opacity: Double) {
        self.opacity = opacity
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .opacity(configuration.isActive ? opacity : 1)
    }
}

// MARK: - Previews

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
struct OpacityEffect_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(0..<10) { index in
                Rectangle()
                    .fill(.blue)
                    .scheduledEffect(
                        .opacity(Double(index) / 10),
                        interval: 1
                    )
            }
        }
        .ignoresSafeArea()
    }
}
