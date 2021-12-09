//
//  ItemPhotoCell.swift
//  DP1
//
//  Created by Sergii Kotyk on 15/6/21.
//

import UIKit

class ItemPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var PhotoView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.PhotoView.image = nil
    }
}
