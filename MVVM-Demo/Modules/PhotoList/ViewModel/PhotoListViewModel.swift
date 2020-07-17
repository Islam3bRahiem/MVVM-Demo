//
//  PhotoListViewModel.swift
//  MVVM-Demo
//
//  Created by Islam 3bRahiem on 7/17/20.
//  Copyright © 2020 Organization. All rights reserved.
//

import Foundation

public enum State {
    case loading
    case error
    case empty
    case populated
}

class PhotoListViewModel {
    
    private let apiService: APIServiceProtocol
    private var photos = [Photo]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    var didSelectImageURL: String? {
        didSet {
            self.navigateToImageDetailsViewController?()
        }
    }
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var navigateToImageDetailsViewController: (()->())?

    
    
    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    
    
    func initFetch() {
        state = .loading
        apiService.fetchPopularPhoto { [weak self](success, photos, error) in
            guard let self = self else { return }

            guard error == nil else {
                self.state = .error
                self.alertMessage = error?.rawValue
                return
            }

            self.photos = photos
            var vms = [PhotoListCellViewModel]()
            for photo in photos {
                vms.append(self.createCellViewModel(photo: photo))
            }
            self.cellViewModels = vms
            self.state = .populated
        }
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel{
        return cellViewModels[indexPath.row]
    }
    
    func userPressedPhoto(at indexPath: IndexPath) {
        let photo = self.photos[indexPath.row]
        let url = self.photos[indexPath.row].image_url
        if photo.for_sale {
            self.didSelectImageURL = url
        } else {
            self.alertMessage = "This item is not for sale"
        }
    }
    
    
    
    private func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {
        let desc = "\(photo.camera ?? "") - \(photo.description ?? "")"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return PhotoListCellViewModel(titleText: photo.name ,descText: desc, imageUrl: photo.image_url, dateText: dateFormatter.string(from: photo.created_at))
    }
    
    
    
}
