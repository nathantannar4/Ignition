//
// Copyright (c) Nathan Tannar
//

import SwiftUI

/// A value for a ``KeyframeModifier`` at a normalized progress
@frozen
public struct Keyframe<Value: VectorArithmetic>: Equatable {

    public let value: Value
    public let progress: Double

    @inlinable
    public init(
        value: Value,
        progress: Double
    ) {
        self.value = value
        self.progress = progress
    }
}

/// A modifier that sequences an ``Animatable`` modifier's data throughout
/// a series of predefined keyframe values.
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct KeyframeModifier<
    Modifier: ViewModifier & Animatable
>: AnimatableModifier {

    public typealias Keyframe = Ignition.Keyframe<Modifier.AnimatableData>

    public var keyframes: [Keyframe]
    public var modifier: Modifier
    public var isEnabled: Bool
    public var progress: Double

    public var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    @inlinable
    public init(
        keyframes: [Keyframe],
        modifier: Modifier,
        isEnabled: Bool = true,
        progress: Double
    ) {
        self.keyframes = keyframes.sorted(by: { $0.progress <= $1.progress })
        self.modifier = modifier
        self.isEnabled = isEnabled
        self.progress = progress
    }

    @inlinable
    public init(
        values: [Modifier.AnimatableData],
        modifier: Modifier,
        isEnabled: Bool = true,
        progress: Double
    ) {
        let keyframes = values.enumerated().map {
            Keyframe(
                value: $1,
                progress: 1 / Double(values.count - 1) * Double($0)
            )
        }
        self.init(
            keyframes: keyframes,
            modifier: modifier,
            isEnabled: isEnabled,
            progress: progress
        )
    }

    public func body(content: Content) -> some View {
        var m = modifier
        let progress = min(max(self.progress, 0), 1)
        if isEnabled,
            let prev = keyframes.last(where: { $0.progress <= progress }),
            let next = keyframes.first(where: { $0.progress >= progress })
        {
            if prev != next {
                let factor = 1 / (next.progress - prev.progress)
                var val1 = next.value
                val1.scale(by: (progress - prev.progress) * factor)

                var val2 = prev.value
                val2.scale(by: (next.progress - progress) * factor)

                m.animatableData = val1 + val2
            } else {
                m.animatableData = prev.value
            }
        }
        return content.modifier(m)
    }
}

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
extension ViewModifier where Self: Animatable {

    /// Sequences the modifier's data throughout a series of predefined keyframe values.
    @inlinable
    public func keyframes(
        isEnabled: Bool = true,
        progress: Double,
        @KeyframeBuilder<AnimatableData> keyframes: () -> [Keyframe<AnimatableData>]
    ) -> some ViewModifier {
        KeyframeModifier(
            keyframes: keyframes(),
            modifier: self,
            isEnabled: isEnabled,
            progress: progress
        )
    }

    /// Sequences the modifier's data throughout a series of predefined keyframe values.
    @inlinable
    public func keyframes(
        _ values: [AnimatableData],
        isEnabled: Bool = true,
        progress: Double
    ) -> some ViewModifier {
        KeyframeModifier(
            values: values,
            modifier: self,
            isEnabled: isEnabled,
            progress: progress
        )
    }
}

@frozen
@resultBuilder
public struct KeyframeBuilder<Value: VectorArithmetic> {

    @inlinable
    public static func buildBlock() -> [Keyframe<Value>] {
        []
    }

    @inlinable
    public static func buildPartialBlock(
        first: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        first
    }

    @inlinable
    public static func buildPartialBlock(
        accumulated: [Keyframe<Value>],
        next: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        accumulated + next
    }

    @inlinable
    public static func buildExpression(
        _ expression: Keyframe<Value>
    ) -> [Keyframe<Value>] {
        [expression]
    }

    @inlinable
    public static func buildEither(
        first component: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        component
    }

    @inlinable
    public static func buildEither(
        second component: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        component
    }

    @inlinable
    public static func buildOptional(
        _ component: [Keyframe<Value>]?
    ) -> [Keyframe<Value>] {
        component ?? []
    }

    @inlinable
    public static func buildLimitedAvailability(
        _ component: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        component
    }

    @inlinable
    public static func buildArray(
        _ components: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        components
    }

    @inlinable
    public static func buildBlock(
        _ components: [Keyframe<Value>]...
    ) -> [Keyframe<Value>] {
        components.flatMap { $0 }
    }

    public static func buildFinalResult(
        _ component: [Keyframe<Value>]
    ) -> [Keyframe<Value>] {
        component.compactMap { $0 }
    }
}
