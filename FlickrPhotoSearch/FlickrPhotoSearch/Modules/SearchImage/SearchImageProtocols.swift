//
//  SearchImageProtocols.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

protocol SearchImageViewModelType: AnyObject {
    var view: SearchImageVCType? { get set }
    var title: String? { get set }

    init(view: SearchImageVCType, title: String, api: FlickrAPI)
    
    func viewDidLoad()
    func numberOfSections() -> Int
    func numberOfRowsInSection(_ section: Int) -> Int
    func didTapOnImageCellAtIndexPath(_ indexPath: IndexPath)
    func searchImageForText(_ text: String)
    func photoAtIndexPath(_ indexPath: IndexPath) -> Photo?
    func loadImageFromURL(string: String, handler: @escaping ImageLoadResult)
    
}
protocol SearchImageVCType: AnyObject {
    func setTitle(_ title: String)
    func insertPhotoCellsAtIndexPath( _paths: [IndexPath])
    func didStartANewSearch()
    func navigateToDetailsView(model: Photo)
    func receiveZeroResultCount()
    func didFaceErrorWhileSearch(error: String)

    
}
