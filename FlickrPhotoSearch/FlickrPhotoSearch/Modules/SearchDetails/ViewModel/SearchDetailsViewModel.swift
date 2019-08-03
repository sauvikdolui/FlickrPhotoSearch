//
//  SearchDetailsViewModel.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

class SearchDetailsViewModel {
    weak var view: SearchDetailsVCType?
    let title: String?
    private var _photo: Photo?
    private let _api: FlickrAPI
    
    init(view: SearchDetailsVCType, title: String, photo: Photo, api: FlickrAPI) {
        self.title = title
        self.view = view
        self._photo = photo
        self._api = api
    }
    
}

// MARK: - SearchDetailsViewModelType
extension SearchDetailsViewModel : SearchDetailsViewModelType {
    func loadDetailsForImage( id: String) {
        _api.getDetails(id: id) { [weak self](result, error) in
            guard let welf = self else { return }
            if let result = result {
                welf.view?.setDesc(desc: result.photo.getDescription())
                welf.view?.setTags(tags: result.photo.getTagsString(separator: ", "))
            } else if let error = error {
                welf.view?.didFaceErrorLoadingDetails(error: error.localizedDescription)
            }
        }
    }
    func viewDidAppear(animated: Bool) {
        guard let photo = self._photo else {
            return
        }
        loadDetailsForImage(id: photo.id)
        ImageStore.shared.loadImage(url: photo.getImageURL(size: .original )) { (imageData, error) in
            if let error = error {
                self.view?.didFaceErrorInLoadingImage(error: error.localizedDescription)
            } else if let data = imageData {
                self.view?.setImage(data: data)
            }
        }
    }
}
