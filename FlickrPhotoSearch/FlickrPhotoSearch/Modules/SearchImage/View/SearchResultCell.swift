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
    
    weak var viewModel: SearchImageViewModelType?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configWithPhoto(_ photo: Photo) {
        imageNameLabel.text = photo.title
        
        // TODO: Image Load
        viewModel?.loadImageFromURL(string: photo.urlT, handler: { [unowned self] (data, error) in
            if let data = data {
                self.t_imageView.image = UIImage(data: data)
            } else {
                // TODO: Show load error image
            }
            
        })
    }
    override func prepareForReuse() {
        self.t_imageView.image = nil
    }

}
