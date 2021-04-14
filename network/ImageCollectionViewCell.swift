//
//  ImageCollectionViewCell.swift
//  network
//
//  Created by Виктория Козырева on 09.04.2021.
//

import UIKit
import SDWebImage

struct ImageCollectionViewModel {
    var url: URL
}

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
        //SDAnimatedImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func config(url: URL?) {
        if let url = url {
            imageView.sd_setImage(with: url)
        }
        
    }

}
