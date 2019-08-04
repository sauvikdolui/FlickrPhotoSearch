//
//  SearchDetailsProtocols.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import Foundation

protocol SearchDetailsViewModelType {
    func loadDetailsForImage( id: String)
    func viewDidAppear(animated: Bool)
}

protocol SearchDetailsVCType: AnyObject {
    func setImage(data: Data)
    func setDesc(desc: String)
    func setTags(tags: String)
    func didFaceErrorInLoadingImage(error: String)
    func didFaceErrorLoadingDetails(error: String)
}
