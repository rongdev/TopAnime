//
//  TAMyViewController.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/18.
//

import UIKit
import SafariServices
import DZNEmptyDataSet

class TAMyViewController: UIViewController {
    @IBOutlet private weak var cvFavorite: UICollectionView!
    @IBOutlet private weak var lbTotal: UILabel!
    
    let kCellIdentifier = "TAMyCollectionViewCell"
    
    private var aryFavorite: [Favorite] = [] {
        didSet {
            bShouldDisplayEmptyDataSet = aryFavorite.count == 0
        }
    }
    
    private var bShouldDisplayEmptyDataSet: Bool = false {
        didSet {
            guard cvFavorite != nil else { return }
            cvFavorite.reloadData()
            lbTotal.text = "\(LStringFormat("Text:Total", aryFavorite.count))"
        }
    }
    
    private var segmentType: SegmentType = .anime {
        didSet {
            reloadFavorite()
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initTest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Init Methods
    private func initTest() {
        cvFavorite.accessibilityIdentifier = "cvFavorite"
    }
    
    private func initView() {
        title = LString("Title:My")
        segmentType = .anime
        
        addToolButton(.generate(icon: UIImage.trash,
                                     target: self,
                                     action: #selector(removeAllFavorite)))
        
        cvFavorite.dataSource = self
        cvFavorite.delegate = self
        cvFavorite.emptyDataSetSource = self
        cvFavorite.emptyDataSetDelegate = self
        cvFavorite.register(TAMyCollectionViewCell.loadFromNib(),
                         forCellWithReuseIdentifier: kCellIdentifier)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        segmentType = SegmentType(rawValue: sender.selectedSegmentIndex) ?? .anime
    }
    
    @objc private func removeAllFavorite() {
        SUtility.showAsk(msg: LStringFormat("AlertInfo:RemoveAll", String(describing: segmentType))) {
            TACore.shared.removeFavorite(type: self.segmentType)
        }
    }
    
    // MARK: - Publish Methods
    func reloadFavorite() {
        aryFavorite = TACore.shared.aryFavorite.filter({ $0.type ==  segmentType.rawValue})
    }
    
    func removeFavorite(_ favorite: Favorite) {
        guard let uuid = favorite.uuid else { return }
        
        TACore.shared.removeFavorite(uuid)
    }
}

extension TAMyViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        let isScrollDown = translation.y < 0
        
        hideToolButton(hide: isScrollDown)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryFavorite.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! TAMyCollectionViewCell
        
        cell.configureCell(indexPath: indexPath, rows: aryFavorite)
        cell.unfavBlock = {favorite in self.removeFavorite(favorite) }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wt = collectionView.frame.width
        let ht = wt*(321/225)
        return CGSize(width: wt, height: ht/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let urlString = aryFavorite[indexPath.row].url, let url = URL(string: urlString) else {
            return
        }
        
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        present(safari, animated: true, completion: nil)
    }
    
    // MARK: DZNEmptyDataSet
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: LString("Text:Empty"))
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return bShouldDisplayEmptyDataSet
    }
}
