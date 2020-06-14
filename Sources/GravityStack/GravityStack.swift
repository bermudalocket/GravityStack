import SwiftUI

#if os(iOS)
import UIKit
#elseif os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#elseif os(watchOS)
import WatchKit
#endif

/// A versatile stack view that pulls its contents in a given direction.
///
///               | .leading  | .trailing |
/// |             |           |           |
/// | .horizontal |   X...    |   ...X    |
/// |             |           |           |
/// |             |    X      |     .     |
/// | .vertical   |    .      |     .     |
/// |             |    .      |     X     |
///
@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
struct GravityStack<Content: View>: View {

    enum Gravity {
        case leading, trailing
    }

    enum Orientation {
        case horizontal, vertical
    }

    ///
    /// The orientation in which the contents of this view should be
    /// organized, i.e. horizontally or vertically
    private let orientation: Orientation

    ///
    /// The contents subject to "gravity"
    private let content: Content

    ///
    /// The direction in which to push the contents of the view, e.g.
    /// Gravity.leading pushes the contents to the left or up
    private let gravity: Gravity

    ///
    /// A **double** in the interval [0, 1], representing the minimum width
    /// in terms of a percentage of the parent view's width. Note that choices
    /// close to the endpoints of this interval don't really make much sense
    /// in a practical sense. Set to nil to leave the formatting to SwiftUI.
    private let gravityStrength: Double?

    init(_ type: Orientation = .horizontal, gravity: Gravity = .leading, strength: Double? = nil, @ViewBuilder _ content: () -> Content) {
        self.content = content()
        self.orientation = type
        self.gravity = gravity
        self.gravityStrength = strength
    }

    private var screenWidth: CGFloat {
        #if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)
        return UIScreen.main.bounds.size.width
        #elseif os(macOS)
        return NSApplication.shared.keyWindow?.frame.size.width ?? 400.0
        #elseif os(watchOS)
        return WKInterfaceDevice.current().screenBounds.size.width
        #endif
    }

    private var modifiedSpacer: some View {
        Group {
            if self.gravityStrength != nil {
                Spacer()
                    .frame(minWidth: screenWidth * CGFloat(gravityStrength!))
            } else {
                Spacer()
            }
        }
    }

    var body: some View {
        Group {
            if self.orientation == .horizontal {
                if self.gravity == .leading {
                    HStack {
                        self.content
                        self.modifiedSpacer
                    }
                } else {
                    HStack {
                        self.modifiedSpacer
                        self.content
                    }
                }
            } else {
                if self.gravity == .leading {
                    VStack {
                        self.content
                        self.modifiedSpacer
                    }
                } else {
                    VStack {
                        self.modifiedSpacer
                        self.content
                    }
                }
            }
        }
    }

}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
struct HGravityStack<T: View>: View {

    ///
    /// The contents subject to "gravity"
    private let content: T

    ///
    /// The direction in which to push the contents of the view, e.g.
    /// Gravity.leading pushes the contents to the left or up
    private let gravity: GravityStack<T>.Gravity

    ///
    /// A **double** in the interval [0, 1], representing the minimum width
    /// in terms of a percentage of the parent view's width. Note that choices
    /// close to the endpoints of this interval don't really make much sense
    /// in a practical sense. Set to nil to leave the formatting to SwiftUI.
    private let gravityStrength: Double?

    init(_ gravity: GravityStack<T>.Gravity = .leading, strength: Double? = nil, @ViewBuilder _ content: () -> T) {
        self.content = content()
        self.gravity = gravity
        self.gravityStrength = strength
    }

    var body: some View {
        GravityStack(.horizontal, gravity: self.gravity, strength: self.gravityStrength) {
            self.content
        }
    }

}

@available(iOS 13, macOS 10.15, tvOS 13, watchOS 6, *)
struct VGravityStack<T: View>: View {

    ///
    /// The contents subject to "gravity"
    private let content: T

    ///
    /// The direction in which to push the contents of the view, e.g.
    /// Gravity.leading pushes the contents to the left or up
    private let gravity: GravityStack<T>.Gravity

    ///
    /// A **double** in the interval [0, 1], representing the minimum width
    /// in terms of a percentage of the parent view's width. Note that choices
    /// close to the endpoints of this interval don't really make much sense
    /// in a practical sense. Set to nil to leave the formatting to SwiftUI.
    private let gravityStrength: Double?

    init(_ gravity: GravityStack<T>.Gravity = .leading, strength: Double? = nil, @ViewBuilder _ content: () -> T) {
        self.content = content()
        self.gravity = gravity
        self.gravityStrength = strength
    }

    var body: some View {
        GravityStack(.vertical, gravity: self.gravity, strength: self.gravityStrength) {
            self.content
        }
    }

}
