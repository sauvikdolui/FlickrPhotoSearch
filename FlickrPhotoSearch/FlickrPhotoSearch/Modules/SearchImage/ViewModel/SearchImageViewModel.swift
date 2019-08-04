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
    private let _imageStore: ImageStore
    private var _ongoingSearchTask: URLSessionDataTask?
    
    required init(view: SearchImageVCType, title: String, api: FlickrAPI, imageStore: ImageStore){
        self.view = view
        self.title = title
        self._api = api
        self._imageStore = imageStore
    }
    func viewDidLoad() {
        self.view?.setTitle(self.title!)
    }
    func loadImageForIndexPath(indexPath: IndexPath, handler: @escaping ImageLoadResult) {
        guard indexPath.row < self._results.count else { return }
        let photo =  _results[indexPath.row]

        // Check cache
        if let imageData = _imageStore.getImageData(key: photo.urlT) {
            _results[indexPath.row].photoLoadStatus = .loaded
            view?.imageLoadStatusChangedTo(status: .loaded, at: indexPath)
            view?.imageDataLoadedFor(indexPath: indexPath, data: imageData, error: nil)
            return
        }
        
        // Donload API
        _results[indexPath.row].photoLoadStatus = .loading
        view?.imageLoadStatusChangedTo(status: .loading, at: indexPath)

        _imageStore.loadImage(url: _results[indexPath.row].urlT, handler: { [weak self] (data, error) in
            guard let welf = self else { return }
            guard indexPath.row < welf._results.count else { return }
            if let _ = error {
                welf._results[indexPath.row].photoLoadStatus = .loadError
            } else if let _ = data {
                welf._results[indexPath.row].photoLoadStatus = .loaded
            }
            welf.view?.imageLoadStatusChangedTo(status: welf._results[indexPath.row].photoLoadStatus, at: indexPath)
            welf.view?.imageDataLoadedFor(indexPath: indexPath, data: data, error: error)
        })
    }
    
    // TODO: invalidate all on going network requests when search string changes

    
}

// MARK: - SearchImageViewModelType
extension SearchImageViewModel: SearchImageViewModelType {
    func searchImageForText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 0 else {
            return
        }
        _ongoingSearchTask?.cancel()
        self._results = [Photo]()
        self.view?.didStartANewSearch()
        
        
        _ongoingSearchTask = _api.searchImage(searchText: trimmed) { [weak self] (result, error) in
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
