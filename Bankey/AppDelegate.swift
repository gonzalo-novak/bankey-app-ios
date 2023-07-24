//
//  AppDelegate.swift
//  Bankey
//

import UIKit

let appColor: UIColor = .systemPurple

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    let loginViewController = LoginViewController()
    let onboardingViewController = OnboardingContainerViewController()
    let dummyViewController = DummyViewController()
    let mainViewController = MainViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.makeKeyAndVisible();
        window?.backgroundColor = .systemBackground;
        
        loginViewController.delegate = self
        onboardingViewController.delegate = self
        dummyViewController.logoutDelegate = self
        
        window?.rootViewController = mainViewController;
        mainViewController.selectedIndex = 0
        return true
    }
}

// MARK: Protocols
extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(dummyViewController)
        } else {
            setRootViewController(onboardingViewController)
        }
    }
}
extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding(){
        LocalState.hasOnboarded = true
        setRootViewController(dummyViewController)
    }
}
extension AppDelegate: LogoutDelegate{
    func didLogout(){
        setRootViewController(loginViewController)
    }
}

// MARK: Utilties
extension AppDelegate {
    
    // Set a given vc onto the root view controller, adding a smooth animation
    // while doing so
    func setRootViewController(_ vc: UIViewController, animated: Bool = true) {
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.7, options: .transitionCrossDissolve, animations: nil)
    }
}
