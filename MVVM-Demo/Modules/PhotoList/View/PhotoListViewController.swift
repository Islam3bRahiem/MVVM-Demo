//
//  PhotoListViewController.swift
//  MVVM-Demo
//
//  Created by Islam 3bRahiem on 7/17/20.
//  Copyright © 2020 Organization. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var viewModel: PhotoListViewModel = {
        return PhotoListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Init the static view
        initView()
        
        // init view model
        initViewModel()
    }
    
    private func initView() {
        self.navigationItem.title = "Popular"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func initViewModel() {
        viewModel.showAlertClosure = { [weak self]() in
            guard let self = self else { return }
            if let msg = self.viewModel.alertMessage {
                DispatchQueue.main.async {
                    self.showAlert(msg)
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self]() in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self]() in
            guard let self = self else { return }
            switch self.viewModel.state {
            case .empty:
                DispatchQueue.main.async{
                    self.activityIndicator.stopAnimating()
                    self.showAlert("Empty data")
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                }
            case .error:
                DispatchQueue.main.async{
                    self.activityIndicator.stopAnimating()
                    self.showAlert("Connection Error")
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                }
            case .loading:
                DispatchQueue.main.async{
                    self.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 0.0
                    })
                }
            case .populated:
                DispatchQueue.main.async{
                    self.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.navigateToImageDetailsViewController = { [weak self]() in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let url = self.viewModel.didSelectImageURL {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
                    vc.imageUrl = url
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        viewModel.initFetch()
        
    }
    
    private func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}


extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoCellIdentifier", for: indexPath) as? PhotoListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.photoListCellViewModel = cellVM
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userPressedPhoto(at: indexPath)
    }
    
}
