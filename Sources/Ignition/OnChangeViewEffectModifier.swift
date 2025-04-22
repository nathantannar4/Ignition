//
// Copyright (c) Nathan Tannar
//

import SwiftUI
import Engine

/// A modifier that adds a ``ViewEffect`` to a view
/// that runs when the value changes
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OnChangeViewEffectModifier<
    Effect: ViewEffect,
    Value: Equatable
>: ViewModifier {

    public var effect: Effect
    public var value: Value
    public var animation: ViewEffectAnimation
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
        animation: ViewEffectAnimation = .default,
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
                OnChangeViewEffectModifierBody(
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

    /// Adds a ``ViewEffect`` animation to a view that runs when the value changes
    @_disfavoredOverload
    @inlinable
    public func changeEffect<
        Effect: ViewEffect,
        Value: Equatable
    >(
        _ effect: Effect,
        value: Value,
        animation: Animation,
        isEnabled: Bool = true
    ) -> some View {
        changeEffect(
            effect,
            value: value,
            animation: .continuous(animation),
            isEnabled: isEnabled
        )
    }

    /// Adds a ``ViewEffect`` animation to a view that runs when the value changes
    @inlinable
    public func changeEffect<
        Effect: ViewEffect,
        Value: Equatable
    >(
        _ effect: Effect,
        value: Value,
        animation: ViewEffectAnimation = .default,
        isEnabled: Bool = true
    ) -> some View {
        modifier(
            OnChangeViewEffectModifier(
                effect: effect,
                value: value,
                animation: animation,
                isEnabled: isEnabled
            )
        )
    }
}

// Using AnimatableModifier due to:
// FB13095046 - Animation behaviour broken for Animatable when type imported from framework
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct OnChangeViewEffectModifierBody<
    Effect: ViewEffect
>: AnimatableModifier {

    var effect: Effect
    var isActive: Binding<Bool>
    var id: UInt
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    private struct OnChangeValue: Equatable {
        var isComplete: Bool
        var id: UInt
    }

    init(
        effect: Effect,
        isActive: Binding<Bool>,
        id: UInt
    ) {
        self.effect = effect
        self.isActive = isActive
        self.id = id
        self.progress = isActive.wrappedValue ? 1 : 0
    }

    func body(content: Content) -> some View {
        content
            .modifier(
                ViewEffectModifier(
                    effect: effect,
                    configuration: ViewEffectConfiguration(
                        id: ViewEffectConfiguration.ID(value: id),
                        isActive: isActive.wrappedValue,
                        progress: progress
                    )
                )
                .transaction { $0.disablesAnimations = true }
            )
            .onChange(
                of: OnChangeValue(isComplete: progress >= 1, id: id)
            ) { value in
                if value.isComplete {
                    isActive.wrappedValue = false
                }
            }
    }
}

/*
 This approach works for some types of effects, but not effects that
 generate views such as .overlay and .background. Moreover, it does
 not allow the animation curve to be different between presentation
 and dismissal.
 
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
@frozen
public struct OnChangeViewEffectModifier<
    Effect: ViewEffect,
    Value: Equatable
>: ViewModifier {

    public var effect: Effect
    public var value: Value
    public var animation: Animation
    public var isEnabled: Bool

    @State private var id: UInt = 0
    @State private var isActive: Bool = false
    @State private var trigger: Bool = false

    @inlinable
    public init(
        effect: Effect,
        value: Value,
        animation: Animation = .default,
        isEnabled: Bool = true
    ) {
        self.effect = effect
        self.value = value
        self.animation = animation
        self.isEnabled = isEnabled
    }

    public func body(content: Content) -> some View {
        content
            .modifier(
                OnChangeViewEffectModifierBody(
                    effect: effect,
                    trigger: trigger,
                    id: id
                )
                .animation(animation)
            )
            .onChange(of: value) { _ in
                if isEnabled {
                    id = id &+ 1
                    trigger.toggle()
                    isActive = true
                }
            }
    }
}

// Using AnimatableModifier due to:
// FB13095046 - Animation behaviour broken for Animatable when type imported from framework
@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
private struct OnChangeViewEffectModifierBody<
    Effect: ViewEffect
>: AnimatableModifier {

    var effect: Effect
    var trigger: Bool
    var id: UInt
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    var configuration: ViewEffectConfiguration {
        let isActive = trigger ? progress <= 0.5 : progress > 0.5
        var progress = min(max(self.progress, 0), 1)
        if !trigger {
            progress = 1 - progress
        }
        if isActive {
            progress = progress * 2
        } else {
            progress = 1 - (progress - 0.5) * 2
        }
        return ViewEffectConfiguration(
            id: ViewEffectConfiguration.ID(value: id),
            isActive: isActive,
            progress: progress
        )
    }

    init(
        effect: Effect,
        trigger: Bool,
        id: UInt
    ) {
        self.effect = effect
        self.trigger = trigger
        self.id = id
        self.progress = trigger ? 1 : 0
    }

    public func body(content: Content) -> some View {
        content
            .modifier(
                ViewEffectModifier(
                    effect: effect,
                    configuration: configuration
                )
                .transaction { $0.disablesAnimations = true }
            )
    }
}
*/

// MARK: - Previews

#if os(iOS) || os(macOS)

@available(iOS 14.0, macOS 11.0, *)
struct OnChangeViewEffectModifier_Previews: PreviewProvider {
    struct PreviewEffect: ViewEffect {
        func makeBody(configuration: Configuration) -> some View {
            configuration.content
                .onChange(of: configuration.progress) { newValue in
                    print(newValue)
                }
        }
    }

    struct Preview: View {
        @State var trigger = 0

        var body: some View {
            VStack {
                ZStack {
                    Color.blue

                    Text("Trigger")
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100)
                .changeEffect(
                    .opacity,
                    value: trigger
                )

                ZStack {
                    Color.blue

                    Text("Trigger")
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100)
                .changeEffect(
                    .background {
                        Rectangle()
                            .stroke(Color.blue, lineWidth: 2)
                            .padding(-2)
                            .transition(
                                .asymmetric(
                                    insertion: .scale(scale: 0.5),
                                    removal: .scale(scale: 2)
                                )
                                .combined(with: .opacity)
                            )
                    },
                    value: trigger
                )
            }
            .onTapGesture {
                trigger += 1
            }
        }
    }

    static var previews: some View {
        Preview()
    }
}

#endif
