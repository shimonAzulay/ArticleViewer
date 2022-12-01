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
  
  
  private lazy var userNameTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = .lightGray
    textField.placeholder = "Username"
    textField.layer.cornerRadius = 5
    textField.addTarget(self, action: #selector(userNameTextFieldDidEnd), for: .editingChanged)
    return textField
  }()
  
  private lazy var passwordTextField: UITextField = {
    let textField = UITextField()
    textField.backgroundColor = .lightGray
    textField.placeholder = "Password"
    textField.layer.cornerRadius = 5
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
  
  var coordinator: Coordinator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupKeyboard()
    setupScrollView()
    setupImageView()
    setupTextFields()
    setupButton()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
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
    coordinator?.show(screen: .articles)
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
    containerView.addArrangedSubview(userNameTextField)
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
    loginButton.isEnabled = userNameTextField.text?.isEmpty == false &&  passwordTextField.text?.isEmpty == false
  }
}
