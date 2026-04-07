//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Combine
import Engine

/// A modifier that adds a ``ViewEffect`` to a view
/// that runs on an interval
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct ScheduledViewEffectModifier<
    Effect: ViewEffect
>: ViewModifier {

    public var effect: Effect
    public var interval: TimeInterval
    public var animation: ViewEffectAnimation
    public var isEnabled: Bool

    @_disfavoredOverload
    @inlinable
    public init(
        effect: Effect,
        interval: TimeInterval,
        animation: Animation,
        isEnabled: Bool = true
    ) {
        self.init(
            effect: effect,
            interval: interval,
            animation: .continuous(animation),
            isEnabled: isEnabled
        )
    }

    @inlinable
    public init(
        effect: Effect,
        interval: TimeInterval,
        animation: ViewEffectAnimation = .default,
        isEnabled: Bool = true
    ) {
        self.effect = effect
        self.interval = interval
        self.animation = animation
        self.isEnabled = isEnabled
    }

    public func body(content: Content) -> some View {
        content
            .modifier(
                ScheduledViewEffectModifierBody(
                    effect: effect,
                    interval: interval,
                    animation: animation,
                    isEnabled: isEnabled
                )
            )
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct ScheduledViewEffectModifierBody<Effect: ViewEffect>: ViewModifier {

    var effect: Effect
    var interval: TimeInterval
    var animation: ViewEffectAnimation
    var isEnabled: Bool

    @State var trigger: UInt = 0

    func body(content: Content) -> some View {
        content
            .changeEffect(effect, value: trigger, animation: animation, isEnabled: isEnabled)
            .onReceive(
                Timer.publish(every: interval, on: .main, in: .common).autoconnect()
            ) { _ in
                if isEnabled {
                    trigger &+= 1
                }
            }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// Adds a ``ViewEffect`` animation to a view that runs on an interval
    @_disfavoredOverload
    @inlinable
    public func scheduledEffect<
        Effect: ViewEffect
    >(
        _ effect: Effect,
        interval: TimeInterval,
        animation: Animation,
        isEnabled: Bool = true
    ) -> some View {
        scheduledEffect(
            effect,
            interval: interval,
            animation: .continuous(animation),
            isEnabled: isEnabled
        )
    }

    /// Adds a ``ViewEffect`` animation to a view that runs on an interval
    @inlinable
    public func scheduledEffect<
        Effect: ViewEffect
    >(
        _ effect: Effect,
        interval: TimeInterval,
        animation: ViewEffectAnimation = .default,
        isEnabled: Bool = true
    ) -> some View {
        modifier(
            ScheduledViewEffectModifier(
                effect: effect,
                interval: interval,
                animation: animation,
                isEnabled: isEnabled
            )
        )
    }
}
