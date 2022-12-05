//
//  LoginViewController.swift
//  ArticleViewer
//
//  Created by Shimon Azulay on 01/12/2022.
//

import UIKit

class LoginViewController: UIViewController {
  private lazy var scrollView: UIScrollView = {
    UIScrollView()
  }()
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    guard let image = UIImage(named: "loginScreenImage") else {
      return imageView
    }
    
    imageView.image = image
    return imageView
  }()
  
  private lazy var containerView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 10
    return stackView
  }()
  
  
  private lazy var usernameTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = .lightGray
    textField.placeholder = "Username"
    textField.layer.cornerRadius = 5
    textField.textColor = .black
    textField.addTarget(self, action: #selector(userNameTextFieldDidEnd), for: .editingChanged)
    return textField
  }()
  
  private lazy var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = .lightGray
    textField.placeholder = "Password"
    textField.layer.cornerRadius = 5
    textField.textColor = .black
    textField.isSecureTextEntry = true
    textField.addTarget(self, action: #selector(passwordTextFieldDidEnd), for: .editingChanged)
    return textField
  }()
  
  private lazy var loginButton: UIButton = {
    let loginButton = UIButton(type: .system)
    loginButton.setTitle("LOGIN", for: .normal)
    loginButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    return loginButton
  }()
  
  let coordinator: Coordinator
  let sessionManager: SessionManager
  
  init(coordinator: Coordinator,
       sessionManager: SessionManager) {
    self.coordinator = coordinator
    self.sessionManager = sessionManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupKeyboard()
    setupScrollView()
    setupImageView()
    setupTextFields()
    setupButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    toggleLoginButtonEnablement()
  }
  
  @objc func userNameTextFieldDidEnd(_ textField: UITextField) {
    toggleLoginButtonEnablement()
  }
  
  @objc func passwordTextFieldDidEnd(_ textField: UITextField) {
    toggleLoginButtonEnablement()
  }
  
  @objc func loginButtonTapped(_ button: UIButton) {
    dismissKeyboard()
    guard let username = usernameTextField.text,
          let password = passwordTextField.text else { return }
    Task {
      do {
        try await sessionManager.login(username: username, password: password)
        coordinator.show(screen: .articles)
      } catch {
        showAlert(withMessage: "\(error)")
      }
    }
  }
  
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }
}

private extension LoginViewController {
  func setupKeyboard() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  func setupScrollView() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(scrollView)
    scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
  }
  
  func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(imageView)
    imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
    imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.95).isActive = true
    imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 5).isActive = true
  }
  
  func setupTextFields() {
    containerView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(containerView)
    containerView.addArrangedSubview(usernameTextField)
    containerView.addArrangedSubview(passwordTextField)
    containerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    containerView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
    containerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7).isActive = true
    containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
  }
  
  func setupButton() {
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(loginButton)
    loginButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10).isActive = true
    loginButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
    loginButton.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor).isActive = true
  }
  
  func toggleLoginButtonEnablement() {
    loginButton.isEnabled = usernameTextField.text?.isEmpty == false &&  passwordTextField.text?.isEmpty == false
  }
  
  func showAlert(withMessage message: String) {
    DispatchQueue.main.async { [weak self] in
      let dialogMessage = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel)
      dialogMessage.addAction(cancelAction)
      self?.present(dialogMessage, animated: true)
    }
  }
}
