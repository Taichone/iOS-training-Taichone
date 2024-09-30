import UIKit

protocol Instantiatable {
    associatedtype Args
    init?(coder: NSCoder, args: Args)
    static var storyboardName: String { get }
    static func instantiateFromStoryboard(with args: Args) -> Self
}

extension Instantiatable where Self: UIViewController {
    static var storyboardName: String {
        return ""
    }
    
    private static var _storyboardName: String {
        if storyboardName.isEmpty {
            return className
        } else {
            return storyboardName
        }
    }

    private static var storyboard: UIStoryboard {
        return UIStoryboard.init(name: _storyboardName, bundle: nil)
    }

    private static var className: String {
        return String(describing: Self.self)
    }

    static func instantiateFromStoryboard(with args: Args) -> Self {
        guard let vc = storyboard.instantiateInitialViewController(creator: { coder in
            return Self.init(coder: coder, args: args)
        }) else {
            fatalError("Can not instantiate \(Self.className) from \(storyboardName).storyboard")
        }
        return vc
    }
}
