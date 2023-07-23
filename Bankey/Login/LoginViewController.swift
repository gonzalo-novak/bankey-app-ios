//
//  ViewController.swift
//  Bankey
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

class LoginViewController: UIViewController {
    let titleElement = UILabel()
    let subtitleElement = UILabel()
    let loginView = LoginView()
    let signInButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    weak var delegate: LoginViewControllerDelegate?
    var username: String? { return loginView.usernameTextField.text }
    var password: String? { return loginView.passwordTextField.text }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        style()
        layout()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        signInButton.configuration?.showsActivityIndicator = false
        loginView.usernameTextField.text = ""
        loginView.passwordTextField.text = ""
    }
}

extension LoginViewController {
    private func style(){
        loginView.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        signInButton.configuration = .filled()
        signInButton.configuration?.imagePadding = 8
        signInButton.setTitle("Sign In", for: [])
        signInButton.addTarget(self, action: #selector(signInTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.isHidden = true
        
        titleElement.translatesAutoresizingMaskIntoConstraints = false
        titleElement.text = "Bankey"
        titleElement.textAlignment = .center
        titleElement.font = UIFont.preferredFont(forTextStyle: .title1)
        titleElement.adjustsFontForContentSizeCategory = true
        
        subtitleElement.translatesAutoresizingMaskIntoConstraints = false
        subtitleElement.text = "Your Premium source for all things banking!"
        subtitleElement.textAlignment = .center
        subtitleElement.font = UIFont.preferredFont(forTextStyle: .body)
        titleElement.adjustsFontForContentSizeCategory = true
    }
    
    private func layout(){
        view.addSubview(titleElement)
        view.addSubview(subtitleElement)
        view.addSubview(loginView)
        view.addSubview(signInButton)
        view.addSubview(errorMessageLabel)
        
        // Title
        NSLayoutConstraint.activate([
            titleElement.leadingAnchor.constraint(equalTo: subtitleElement.leadingAnchor),
            titleElement.trailingAnchor.constraint(equalTo: subtitleElement.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            subtitleElement.topAnchor.constraint(equalToSystemSpacingBelow: titleElement.bottomAnchor, multiplier: 3),
            subtitleElement.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            subtitleElement.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Login View
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: subtitleElement.bottomAnchor, multiplier: 2),
            loginView.centerYAnchor.constraint(equalTo: view.centerYAnchor), // Put it in the middle
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1 /* 1x = 8pts */), // Left padding
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1 /* 1x = 8pts */), // Right padding
        ])
        
        // Sign in View
        NSLayoutConstraint.activate([
           signInButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
           signInButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
           signInButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Error Label View
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: signInButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: signInButton.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: signInButton.trailingAnchor)
        ])
    }
}

extension LoginViewController {
    @objc func signInTapped(){
        errorMessageLabel.isHidden = true // Let's assume there's no error
        login()
    }
    
    private func login() {
        guard let username = username, let password = password else { assertionFailure("Username/Password should never be nil")
            return
        }

        if username.isEmpty || password.isEmpty {
            configureView(withMessage: "Username / Password cannot be blank")
            return
        }
        
        if username == "Admin" && password == "Admin" {
            signInButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin() // Hey everyone is using this method! We finished login
        } else {
            configureView(withMessage: "Incorrect user / password")
        }
    }
    
    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
    }
}
