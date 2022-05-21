//
//  TAMangaCollectionViewCell.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import UIKit

class TAMangaCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var vContent: UIView!
    @IBOutlet private weak var ivImage: UIImageView!
    @IBOutlet private weak var lbTitle: UILabel!
    @IBOutlet private weak var lbRank: UILabel!
    @IBOutlet private weak var lbDate: UILabel!
    @IBOutlet private weak var btnFavorite: SButton!
    
    var favBlock: (() -> Void)? = nil
    var malId: Int = 0
    var isFavorite: Bool = false {
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
        isFavorite = false
        vContent.setShadow(offsetX: 2.0, offsetY: 2.0, shadowBlur: 9.0)
    }
    
    // MARK: - IBAction
    @IBAction func clickFavorite(_ sender: Any) {
        favBlock?()
    }
    
    // MARK: - Configuration
    func configureCell(indexPath: IndexPath, rows: [MangaItem]) {
        let row = rows[indexPath.row]
        
        malId = row.malId
        ivImage.setImageWith(row.images.jpg.largeImageUrl)
        lbTitle.text = row.title
        lbRank.text = "\(row.rank)"
        lbDate.text = "\(row.published.from.toDate()) ~ \(row.published.to.toDate())"
        
        isFavorite = TACore.isFavorite(type: .manga, malId: row.malId)
    }
}
