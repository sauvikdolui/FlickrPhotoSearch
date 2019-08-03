//
//  SearchDetailsVC.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import UIKit

class SearchDetailsVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var snipper: UIActivityIndicatorView!
    
    
    var viewModel: SearchDetailsViewModelType?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        // UI Testing
        #if DEBUG
        self.view.accessibilityIdentifier = "SearchDetailsVCView"
        #endif
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        snipper.isHidden = false
        snipper.startAnimating()

        viewModel?.viewDidAppear(animated: animated)
    }
    
    
    

}

// MARK: - SearchDetailsVCType Protocol Conformation
extension SearchDetailsVC: SearchDetailsVCType {
    func didFaceErrorInLoadingImage(error: String) {
        // TODO: Show Image Load Error
        snipper.stopAnimating()
        snipper.isHidden = true
    }
    func setImage(data: Data) {
        imageView.image = UIImage(data: data)
        snipper.stopAnimating()
        snipper.isHidden = true
    }
    func setDesc(desc: String) {
        descLabel.text = desc
    }
    func setTags(tags: String) {
        tagsLabel.text = tags
    }
    func didFaceErrorLoadingDetails(error: String) {
        // TODO: Error Handling
    }

    
}
