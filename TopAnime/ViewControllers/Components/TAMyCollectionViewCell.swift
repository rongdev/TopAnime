//
//  TAMyCollectionViewCell.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/20.
//

import UIKit

class TAMyCollectionViewCell : UICollectionViewCell {
    @IBOutlet private weak var vContent: UIView!
    @IBOutlet private weak var ivImage: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbType: UILabel!
    @IBOutlet private weak var btnFavorite: SButton!
    
    var favorite: Favorite? = nil
    var unfavBlock: ((_ favorite: Favorite) -> Void)? = nil
    
    private var isFavorite: Bool = false {
        didSet {
            btnFavorite.setFavorite(isFavorite)
        }
    }
    
    // MARK: - InitView
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    func initView() {
        isFavorite = true
        vContent.setShadow(offsetX: 2.0, offsetY: 2.0, shadowBlur: 9.0)
    }
    
    // MARK: - IBAction
    @IBAction func clickUnfavorite(_ sender: Any) {
        if let favorite = favorite {
            unfavBlock?(favorite)
        }
    }
    
    // MARK: - Configuration
    func configureCell(indexPath: IndexPath, rows: [Favorite]) {
        let row = rows[indexPath.row]
        
        favorite = row
        lbType.text = SegmentType(rawValue: Int(row.type)) == .anime ? LString("Text:Anime") : LString("Text:Manga")
        ivImage.setImageWith(row.img)
        lbTitle.text = row.title
    }
}

