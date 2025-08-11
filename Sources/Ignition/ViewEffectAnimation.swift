//
// Copyright (c) Nathan Tannar
//

import SwiftUI

/// The animation curves for a ``ViewEffectModifier``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ViewEffectAnimation: Sendable {

    public var insertion: Animation?
    public var removal: Animation?

    public static let `default`: ViewEffectAnimation = .continuous(.linear)

    public static let easeInOut: ViewEffectAnimation = .asymmetric(
        insertion: .easeIn.speed(2),
        removal: .easeOut.speed(2)
    )

    public static func easeInOut(duration: TimeInterval) -> ViewEffectAnimation {
        .asymmetric(
            insertion: .easeIn(duration: duration / 2),
            removal: .easeOut(duration: duration / 2)
        )
    }

    public static func continuous(
        _ animation: Animation
    ) -> ViewEffectAnimation {
        ViewEffectAnimation(
            insertion: animation.speed(2),
            removal: animation.speed(2)
        )
    }

    public static func asymmetric(
        insertion: Animation?,
        removal: Animation?
    ) -> ViewEffectAnimation {
        ViewEffectAnimation(
            insertion: insertion,
            removal: removal
        )
    }
}
