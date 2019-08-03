//
//  SearchImageViewModel.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

class SearchImageViewModel {
    weak var view: SearchImageVCType?
    var title: String?
    
    
    private var _results = [Photo]()
    
    private let _api: FlickrAPI
    
    required init(view: SearchImageVCType, title: String, api: FlickrAPI){
        self.view = view
        self.title = title
        self._api = api
    }
    func viewDidLoad() {
        self.view?.setTitle(self.title!)
    }
    func loadImageFromURL(string: String, handler: @escaping ImageLoadResult) {
        ImageStore.shared.loadImage(url: string, handler: handler)
    }

    
}

// MARK: - SearchImageViewModelType
extension SearchImageViewModel: SearchImageViewModelType {
    func searchImageForText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 0 else {
            return
        }
        self._results = [Photo]()
        self.view?.didStartANewSearch()
        
        
        _api.searchImage(searchText: trimmed) { [weak self] (result, error) in
            guard let welf = self else{ return }
            if let result = result {
                welf._results = result.photos.photo
                if welf._results.isEmpty {
                    welf.view?.receiveZeroResultCount()
                } else {
                    welf.view?.insertPhotoCellsAtIndexPath(_paths: (0..<welf._results.count).map { IndexPath(row: $0, section: 0)})
                }
                
            } else if let error = error {
                welf.view?.didFaceErrorWhileSearch(error: error.localizedDescription)
            }
        }
    }
    func photoAtIndexPath(_ indexPath: IndexPath) -> Photo? {
        guard indexPath.row < _results.count else {
            return nil
        }
        return _results[indexPath.row]
    }
    
    
    func numberOfSections() -> Int {
        return _results.isEmpty ? 0 : 1
    }
    func numberOfRowsInSection(_ section: Int) -> Int {
        return _results.isEmpty ? 0 : _results.count
    }
    func didTapOnImageCellAtIndexPath(_ indexPath: IndexPath) {
        guard  indexPath.row < _results.count else {
            return
        }
        view?.navigateToDetailsView(model: _results[indexPath.row])
    }
}
