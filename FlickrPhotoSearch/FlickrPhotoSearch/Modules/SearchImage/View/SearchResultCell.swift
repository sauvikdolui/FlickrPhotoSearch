//
//  SearchResultCell.swift
//  FlickrPhotoSearch
//
//  Created by Sauvik Dolui on 23/07/19.
//  Copyright © 2019 Sauvik Dolu. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var t_imageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    weak var viewModel: SearchImageViewModelType?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithPhoto(_ photo: Photo, indexPath: IndexPath) {
        imageNameLabel.text = photo.title
        self.indexPath = indexPath
    }
    override func prepareForReuse() {
        self.t_imageView.image = nil
    }
    func loadImage() {
        guard let indexPath = self.indexPath else { return }
        spinner.startAnimating()
        spinner.isHidden = false
        
        viewModel?.loadImageForIndexPath(indexPath: indexPath, handler: { (data, error) in
            if let data = data {
                self.t_imageView.image = UIImage(data: data)
            } else {
                // TODO: Show load error image
            }
        })

    }
    func imageLoadUpdate(status: PhotoLoadStatus) {
        switch status {
        case .loading, .unknown:
            spinner.startAnimating()
            spinner.isHidden = false
        case .loaded: ()
            spinner.stopAnimating()
            spinner.isHidden = true
            
        case .loadError:
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    func imageDataLoaded(data: Data?, error: Error?) {
        if let data = data {
            self.t_imageView.image = UIImage(data: data)
        } else if let error = error {
            print("Image Load Error \(error.localizedDescription)")
        }
    }

}
