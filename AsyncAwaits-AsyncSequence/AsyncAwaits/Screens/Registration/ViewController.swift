//
//  ViewController.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 19/01/23.
//

import UIKit

struct Segue{
    static let toHome = "toHome"
    static let toAsyncSequence = "toAsyncSequence"
}

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var TFUsername: UITextField!
    @IBOutlet weak var TFEmail: UITextField!
    @IBOutlet weak var TFPassword: UITextField!
    @IBOutlet weak var registartionLoader: UIActivityIndicatorView!
    
    //MARK: - Variables
    
    private var viewModel = RegistrationViewModel()
    
    //MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - API
    
    func registerUser(_ registartionRequest: RegistrationRequest){
        registartionLoader.startAnimating()
        Task{
            do {
                let result = try await viewModel.getUserRegistered(registartionRequest)
                if let result = result {
                    registartionLoader.stopAnimating()
                    self.performSegue(withIdentifier: Segue.toHome, sender: self)
                }
            } catch let serviceError {
               print(serviceError)
            }
        }
    }
    
    //MARK: - IBActions

    @IBAction func registerPressed(_ sender: Any) {
        if let name = TFUsername.text, let email = TFEmail.text, let pass = TFPassword.text{
            let registrationRequest = RegistrationRequest(Name: name, Email: email, Password: pass)
            registerUser(registrationRequest)
        }
    }
}

