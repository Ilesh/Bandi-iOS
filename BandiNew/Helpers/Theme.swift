//
//  Theme.swift
//  BandiNew
//
//  Created by Siddha Tiwari on 5/19/18.
//  Copyright © 2018 Siddha Tiwari. All rights reserved.
//

import UIKit

struct AppTheme {
    var themeName: String
    var tintColor: UIColor
    var statusBarStyle: UIStatusBarStyle
    
    var isNavBarTranslucent: Bool
    var barStyle: UIBarStyle
    var navBarTintColor: UIColor?
    
    var barBackgroundColor: UIColor
    var barUnselectedTextColor: UIColor
    var buttonBackgroundColor: UIColor
    var backgroundColor: UIColor
    var textColor: UIColor
    var subTextColor: UIColor
    var viewBorderColor: CGColor
    
    var popupBarColor: UIColor
    var popBarBackgroundStyle: UIBlurEffectStyle
    
    var tableBackgroundColor: UIColor
    var tableSeparatorColor: UIColor
    var tableCellBackgroundColor: UIColor
    
    var keyboardAppearance: UIKeyboardAppearance
    
    var loadingCircleStyle: UIActivityIndicatorViewStyle
    
    var musicDetailsMainBackgroundColor: UIColor
    var musicDetailsTopBackgroundColor: UIColor
}

extension AppTheme {
    static let light = AppTheme(
        themeName: "light",
        tintColor: Constants.Colors().primaryColor,
        statusBarStyle: .default,
        isNavBarTranslucent: true,
        barStyle: .default,
        navBarTintColor: .white,
        barBackgroundColor: .white,
        barUnselectedTextColor: .gray,
        buttonBackgroundColor:#colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1),
        backgroundColor: UIColor(white: 1, alpha: 1),
        textColor: .black,
        subTextColor: .gray,
        viewBorderColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor,
        popupBarColor: .white,
        popBarBackgroundStyle: .extraLight,
        tableBackgroundColor: .white,
        tableSeparatorColor: .lightGray,
        tableCellBackgroundColor: #colorLiteral(red: 0.8769902668, green: 0.8769902668, blue: 0.8769902668, alpha: 1),
        keyboardAppearance: .light,
        loadingCircleStyle: .gray,
        musicDetailsMainBackgroundColor: .white,
        musicDetailsTopBackgroundColor: #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
    )
    
    static let dark = AppTheme(
        themeName: "dark",
        tintColor: Constants.Colors().primaryColor,
        statusBarStyle: .lightContent,
        isNavBarTranslucent: true,
        barStyle: .blackTranslucent,
        navBarTintColor: UIColor(red: 0.035, green: 0.035, blue: 0.035, alpha: 1),
        barBackgroundColor: .black,
        barUnselectedTextColor: .lightGray,
        buttonBackgroundColor: #colorLiteral(red: 0.09411764706, green: 0.09411764706, blue: 0.09411764706, alpha: 1),
        backgroundColor: UIColor(white: 0, alpha: 1),
        textColor: .white,
        subTextColor: .lightGray,
        viewBorderColor: UIColor.darkGray.cgColor,
        popupBarColor: .black,
        popBarBackgroundStyle: .dark,
        tableBackgroundColor: UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1),
        tableSeparatorColor: UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1),
        tableCellBackgroundColor: UIColor(red: 0.085, green: 0.085, blue: 0.085, alpha: 1),
        keyboardAppearance: .dark,
        loadingCircleStyle: .white,
        musicDetailsMainBackgroundColor: #colorLiteral(red: 0.0862745098, green: 0.0862745098, blue: 0.0862745098, alpha: 1),
        musicDetailsTopBackgroundColor: Constants.Colors().darkTableCell
    )
}

final class AppThemeProvider: ThemeProvider {
    static let shared: AppThemeProvider = .init()
    
    private var theme: SubscribableValue<AppTheme>
    private var availableThemes: [AppTheme] = [.light, .dark]
    
    var currentTheme: AppTheme {
        get {
            return theme.value // TODO: Simultaneous accesses to 0x1c0184e10, but modification requires exclusive access.
            // Did Exclusive Access to Memory = No Enforcement in Build Settings
        }
        set {
            setNewTheme(newValue)
        }
    }
    
    init() {
        theme = SubscribableValue<AppTheme>(value: .light)
    }
    
    private func setNewTheme(_ newTheme: AppTheme) {
        let window = UIApplication.shared.delegate!.window!!
        UIView.transition(
            with: window,
            duration: 0.2,
            options: [.transitionCrossDissolve],
            animations: {
                self.theme.value = newTheme
        },
            completion: nil
        )
    }
    
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (AppTheme) -> Void) {
        theme.subscribe(object, using: handler)
    }
    
    func nextTheme() {
        guard let nextTheme = availableThemes.rotate() else {
            return
        }
        currentTheme = nextTheme
    }
}

extension Themed where Self: AnyObject {
    var themeProvider: AppThemeProvider {
        return AppThemeProvider.shared
    }
}

/// Describes a type that holds a current `Theme` and allows
/// an object to be notified when the theme is changed.
protocol ThemeProvider {
    /// Placeholder for the theme type that the app will use
    associatedtype Theme
    
    /// The current theme that is active
    var currentTheme: Theme { get }
    
    /// Subscribe to be notified when the theme changes. Handler will be
    /// remove from subscription when `object` is deallocated.
    func subscribeToChanges(_ object: AnyObject, handler: @escaping (Theme) -> Void)
}

/// Describes a type that can have a theme applied to it
protocol Themed {
    /// A Themed type needs to know about what concrete type the
    /// ThemeProvider is. So we don't clash with the protocol,
    /// let's call this associated type _ThemeProvider
    associatedtype _ThemeProvider: ThemeProvider
    
    /// Return the current app-wide theme provider
    var themeProvider: _ThemeProvider { get }
    
    /// This will be called whenever the current theme changes
    func applyTheme(_ theme: _ThemeProvider.Theme)
}

extension Themed where Self: AnyObject {
    /// This is to be called once when Self wants to start listening for
    /// theme changes. This immediately triggers `applyTheme()` with the
    /// current theme.
    func setUpTheming() {
        applyTheme(themeProvider.currentTheme)
        themeProvider.subscribeToChanges(self) { [weak self] newTheme in
            self?.applyTheme(newTheme)
        }
    }
}

extension Array {
    /// Move the last element of the array to the beginning
    ///  - Returns: The element that was moved
    mutating func rotate() -> Element? {
        guard let lastElement = popLast() else {
            return nil
        }
        insert(lastElement, at: 0)
        return lastElement
    }
}

// A box that allows us to weakly hold on to an object
struct Weak<Object: AnyObject> {
    weak var value: Object?
}

/// Stores a value of type T, and allows objects to subscribe to
/// be notified with this value is changed.
struct SubscribableValue<T> {
    private typealias Subscription = (object: Weak<AnyObject>, handler: (T) -> Void)
    private var subscriptions: [Subscription] = []
    
    var value: T {
        didSet {
            for (object, handler) in subscriptions where object.value != nil {
                handler(value)
            }
        }
    }
    
    init(value: T) {
        self.value = value
    }
    
    mutating func subscribe(_ object: AnyObject, using handler: @escaping (T) -> Void) {
        subscriptions.append((Weak(value: object), handler))
        cleanupSubscriptions()
    }
    
    private mutating func cleanupSubscriptions() {
        subscriptions = subscriptions.filter({ entry in
            return entry.object.value != nil
        })
    }
}

