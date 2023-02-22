//
//  HomeViewController.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 03/02/23.
//

import UIKit

class HomeViewController: UIViewController {
    
   //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvUsers: UITableView!
    @IBOutlet weak var tvDevice: UITableView!
    
    @IBOutlet weak var bgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tvHeight: NSLayoutConstraint!
    @IBOutlet weak var bgUserHeight: NSLayoutConstraint!
    @IBOutlet weak var bgDeviceHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgDevice: UIView!
    @IBOutlet weak var bgUsers: UIView!
    @IBOutlet weak var bgAsyncSequence: UIView!
    
    @IBOutlet weak var deviceLoader: UIActivityIndicatorView!
    @IBOutlet weak var userLoader: UIActivityIndicatorView!
    @IBOutlet weak var payrollLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var getTokenBtn: UIButton!
    
    //MARK: - Variables
    
    private var viewModel = HomeViewModel()
    
    //MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        loadHomeData()
    }
    
    //MARK: - common methods
    
    func setupUI(){
        tvHeight.constant = 0
        bgViewHeight.constant = 50
        bgView.setRoundedCorner()
        bgView.setRoundedShadow()
        
        bgUsers.setRoundedCorner()
        bgUsers.setRoundedShadow()
        
        bgDevice.setRoundedCorner()
        bgDevice.setRoundedShadow()
        
        bgAsyncSequence.setRoundedCorner()
        bgAsyncSequence.setRoundedShadow()
        
        tableView.register(UINib(nibName: HomeTableCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HomeTableCell.reusableIdentifier)
        tvUsers.register(UINib(nibName: HomeTableCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier: HomeTableCell.reusableIdentifier)
        tvDevice.register(UINib(nibName: HomeTableCell.reusableIdentifier, bundle: nil), forCellReuseIdentifier:HomeTableCell.reusableIdentifier)

    }
    
    //MARK: - Data methods
    
    func loadHomeData(){
        deviceLoader.startAnimating()
        userLoader.startAnimating()
        
        // Performing Parrallel Async tasks
        
        Task{
            do{
                let result = try await viewModel.getUsers()
                if let result = result{
                    viewModel.users = result
                    tvUsers.reloadData()
                    userLoader.stopAnimating()
                    bgUserHeight.constant = CGFloat(66 * viewModel.users.count-10)
                }
            }catch let serviceError{
                print(serviceError)
            }
        }
        
        Task{
            do{
                let result = try await viewModel.getDevices()
                if let result = result{
                    viewModel.device = result
                    tvDevice.reloadData()
                    deviceLoader.stopAnimating()
                    bgDeviceHeight.constant = CGFloat(66 * viewModel.device.count-10)
                }
            }catch let serviceError{
                print(serviceError)
            }
        }
    }
    
    func loadData(){
        getTokenBtn.isHidden = true
        payrollLoader.startAnimating()
        
        // Performing serial API call where we are using one API response in second API
        
        Task{
            do {
                let result = try await viewModel.getPayroll()
                if let result = result {
                    viewModel.employeesspayroll = result
                    tvHeight.constant = 200
                    bgViewHeight.constant = 258
                    tableView.reloadData()
                    payrollLoader.stopAnimating()
                }
            } catch let serviceError {
               print(serviceError)
            }
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func showAsyncPressed(_ sender: Any) {
        self.performSegue(withIdentifier: Segue.toAsyncSequence, sender: self)
    }
    
    @IBAction func getTokenPressed(_ sender: Any) {
        loadData()
    }
}

//MARK: - UITableViewDelegate/UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tvUsers{
            return viewModel.users.count
        }else if tableView == tvDevice{
            return viewModel.device.count
        }else{
            return viewModel.employeesspayroll.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableCell.reusableIdentifier, for: indexPath) as! HomeTableCell
        if tableView == tvUsers{
            cell.setUpCellForUsers(viewModel.users[indexPath.row])
            return cell
        }else if tableView == tvDevice{
            cell.setUpCellForDevices(viewModel.device[indexPath.row])
            return cell
        }else{
            cell.setUpCellForEmployeePayroll(viewModel.employeesspayroll[indexPath.row])
            return cell
        }
        
    }
}
