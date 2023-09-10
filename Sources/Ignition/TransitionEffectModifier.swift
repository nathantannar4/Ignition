//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

/// A modifier that adds a ``TransitionEffect`` animation to a view
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct TransitionEffectModifier<
    Effect: TransitionEffectStyle,
    Value: Equatable
>: ViewModifier {

    public var effect: Effect
    public var value: Value
    public var animation: TransitionEffectAnimation
    public var isEnabled: Bool

    @State private var id: UInt = 0
    @State private var isActive = false

    @_disfavoredOverload
    @inlinable
    public init(
        effect: Effect,
        value: Value,
        animation: Animation,
        isEnabled: Bool = true
    ) {
        self.init(
            effect: effect,
            value: value,
            animation: .continuous(animation),
            isEnabled: isEnabled
        )
    }

    @inlinable
    public init(
        effect: Effect,
        value: Value,
        animation: TransitionEffectAnimation = .default,
        isEnabled: Bool = true
    ) {
        self.effect = effect
        self.value = value
        self.animation = animation
        self.isEnabled = isEnabled
    }

    public func body(content: Content) -> some View {
        let animation = (isActive ? animation.insertion : animation.removal) ?? .linear(duration: 0)
        content
            .modifier(
                TransitionEffectModifierBody(
                    effect: effect,
                    isActive: $isActive,
                    id: id
                )
                .animation(animation)
            )
            .onChange(of: value) { _ in
                if isEnabled {
                    id = id &+ 1
                    isActive = true
                }
            }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension View {

    /// A modifier that adds a ``TransitionEffect`` animation to a view
    @_disfavoredOverload
    @inlinable
    public func transitionEffect<
        Effect: TransitionEffectStyle,
        Value: Equatable
    >(
        _ effect: Effect,
        value: Value,
        animation: Animation,
        isEnabled: Bool = true
    ) -> some View {
        transitionEffect(
            effect,
            value: value,
            animation: .continuous(animation),
            isEnabled: isEnabled
        )
    }

    /// A modifier that adds a ``TransitionEffect`` animation to a view
    @inlinable
    public func transitionEffect<
        Effect: TransitionEffectStyle,
        Value: Equatable
    >(
        _ effect: Effect,
        value: Value,
        animation: TransitionEffectAnimation = .default,
        isEnabled: Bool = true
    ) -> some View {
        modifier(
            TransitionEffectModifier(
                effect: effect,
                value: value,
                animation: animation,
                isEnabled: isEnabled
            )
        )
    }
}

/// The animation curve for a ``TransitionEffectModifier``
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct TransitionEffectAnimation {

    public var insertion: Animation?
    public var removal: Animation?

    public static let `default`: TransitionEffectAnimation = .continuous(.linear)

    public static var easeInOut: TransitionEffectAnimation = .asymmetric(
        insertion: .easeIn.speed(2),
        removal: .easeOut.speed(2)
    )

    public static func easeInOut(duration: TimeInterval) -> TransitionEffectAnimation {
        .asymmetric(
            insertion: .easeIn(duration: duration / 2),
            removal: .easeOut(duration: duration / 2)
        )
    }

    public static func continuous(
        _ animation: Animation
    ) -> TransitionEffectAnimation {
        TransitionEffectAnimation(
            insertion: animation.speed(2),
            removal: animation.speed(2)
        )
    }

    public static func asymmetric(
        insertion: Animation?,
        removal: Animation?
    ) -> TransitionEffectAnimation {
        TransitionEffectAnimation(
            insertion: insertion,
            removal: removal
        )
    }
}

// Using AnimatableModifier due to:
// FB13095046 - Animation behaviour broken for Animatable when type imported from framework
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct TransitionEffectModifierBody<
    Effect: TransitionEffectStyle
>: AnimatableModifier {

    var effect: Effect
    var isActive: Binding<Bool>
    var id: UInt
    var animatableData: Double

    init(
        effect: Effect,
        isActive: Binding<Bool>,
        id: UInt
    ) {
        self.effect = effect
        self.isActive = isActive
        self.id = id
        self.animatableData = isActive.wrappedValue ? 1 : 0
    }

    func body(content: Content) -> some View {
        content
            .modifier(
                TransitionEffectStyleModifier(
                    effect: effect,
                    configuration: TransitionEffectConfiguration(
                        id: TransitionEffectConfiguration.ID(value: id),
                        isActive: isActive.wrappedValue,
                        progress: animatableData
                    )
                )
                .transaction { $0.disablesAnimations = true }
            )
            .onChange(of: animatableData >= 1) { isComplete in
                if isComplete {
                    isActive.wrappedValue = false
                }
            }
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct TransitionEffectStyleModifier<Effect: TransitionEffectStyle>: ViewModifier {
    var effect: Effect
    var configuration: Effect.Configuration

    func body(content: Content) -> some View {
        _Body(configuration: configuration)
            .viewAlias(TransitionEffectConfiguration.Content.self) {
                content
            }
            .styledViewStyle(_Body.self, style: effect)
    }

    struct _Body: ViewStyledView {
        var configuration: TransitionEffectConfiguration
        static var defaultStyle: Effect { fatalError() }
    }
}
