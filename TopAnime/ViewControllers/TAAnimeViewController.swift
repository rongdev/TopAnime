//
//  TAAnimeViewController.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/18.
//

import UIKit
import SafariServices

enum SegmentType: Int {
    case anime
    case manga
}

class TAAnimeViewController: UIViewController {
    @IBOutlet private weak var vAnime: UIStackView!
    @IBOutlet private weak var vManga: UIStackView!
    @IBOutlet private weak var cvAnime: UICollectionView!
    @IBOutlet private weak var cvManga: UICollectionView!
    
    @IBOutlet private weak var txfAnimeType: SDropdownTextField!
    @IBOutlet private weak var txfAnimeFilter: SDropdownTextField!
    @IBOutlet private weak var txfMangaType: SDropdownTextField!
    @IBOutlet private weak var txfMangaFilter: SDropdownTextField!
    
    let kCellIdentifierAnime = "TAAnimeCollectionViewCell"
    let kCellIdentifierManga = "TAMangaCollectionViewCell"
    var iAnimePage: Int = 0
    var iAnimeTotal: Int = -1
    var iMangaPage: Int = 0
    var iMangaTotal: Int = -1
    
    private var aryAnime: [AnimeItem] = [] {
        didSet {
            cvAnime.reloadData()
        }
    }
    
    private var aryManga: [MangaItem] = [] {
        didSet {
            cvManga.reloadData()
        }
    }
    
    private var sAnimeType: AnimeType = .all {
        didSet {
            txfAnimeType.text = sAnimeType.rawValue
        }
    }
    
    private var sAnimeFilter: AnimeFilter = .all {
        didSet {
            txfAnimeFilter.text = sAnimeFilter.rawValue
        }
    }
    
    private var sMangaType: MangaType = .all {
        didSet {
            txfMangaType.text = sMangaType.rawValue
        }
    }
    
    private var sMangaFilter: MangaFilter = .all {
        didSet {
            txfMangaFilter.text = sMangaFilter.rawValue
        }
    }
    
    private lazy var scAnime: UISegmentedControl = {
        let sc = UISegmentedControl(items: [LString("Text:Anime"), LString("Text:Manga")])
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleSegmentChanged(_:)), for: .valueChanged)
        return sc
    }()
    
    private var segmentType: SegmentType = .anime {
        didSet {
            vAnime.isHidden = !(segmentType == .anime)
            vManga.isHidden = !(segmentType == .manga)
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
        
        if iAnimeTotal == -1 { getTopAnime() }
        if iMangaTotal == -1 { getTopManga() }
    }
    
    // MARK: Init Methods
    private func initTest() {
        cvAnime.accessibilityIdentifier = "cvAnime"
        cvManga.accessibilityIdentifier = "cvManga"
        txfAnimeType.accessibilityIdentifier = "txfAnimeType"
        txfAnimeFilter.accessibilityIdentifier = "txfAnimeFilter"
        txfMangaType.accessibilityIdentifier = "txfMangaType"
        txfMangaFilter.accessibilityIdentifier = "txfMangaFilter"
    }
    
    private func initView() {
        navigationItem.titleView = self.scAnime
        segmentType = .anime
        sAnimeType = .all
        sAnimeFilter = .all
        sMangaType = .all
        sMangaFilter = .all
        
        cvAnime.dataSource = self
        cvAnime.delegate = self
        cvAnime.register(TAAnimeCollectionViewCell.loadFromNib(),
                         forCellWithReuseIdentifier: kCellIdentifierAnime)
        cvManga.dataSource = self
        cvManga.delegate = self
        cvManga.register(TAMangaCollectionViewCell.loadFromNib(),
                         forCellWithReuseIdentifier: kCellIdentifierManga)
        
        txfAnimeType.type = .onePicker
        txfAnimeFilter.type = .onePicker
        txfMangaType.type = .onePicker
        txfMangaFilter.type = .onePicker
        
        txfAnimeType.setOnePickerParam(aryItem: AnimeType.allValue()) { index, text in
            self.reloadAnime(type: AnimeType.allCases[index], filter: self.sAnimeFilter)
        }
        
        txfAnimeFilter.setOnePickerParam(aryItem: AnimeFilter.allValue()) { index, text in
            self.reloadAnime(type: self.sAnimeType, filter: AnimeFilter.allCases[index])
        }
        
        txfMangaType.setOnePickerParam(aryItem: MangaType.allValue()) { index, text in
            self.reloadManga(type: MangaType.allCases[index], filter: self.sMangaFilter)
        }
        
        txfMangaFilter.setOnePickerParam(aryItem: MangaFilter.allValue()) { index, text in
            self.reloadManga(type: self.sMangaType, filter: MangaFilter.allCases[index])
        }
    }
    
    // MARK: - IBAction
    @objc private func handleSegmentChanged(_ sender: UISegmentedControl) {
        segmentType = SegmentType(rawValue: sender.selectedSegmentIndex) ?? .anime
    }
    
    // MARK: - HttpClient
    private func getTopAnime() {
        if aryAnime.count != iAnimeTotal {
            iAnimePage+=1
            
            TAHttpClient.getTopAnime(request: TAAnimeRqDTO(type: sAnimeType, filter: sAnimeFilter, page: iAnimePage)) { response in
                self.iAnimeTotal = response.pagination.items.total
                self.aryAnime.append(contentsOf: response.data)
                self.aryAnime = self.aryAnime.sorted(by: { $0.rank < $1.rank })
            } failure: {
                
            }
        }
    }
    
    private func getTopManga() {
        if aryManga.count != iMangaTotal {
            iMangaPage+=1
            
            TAHttpClient.getTopManga(request: TAMangaRqDTO(type: sMangaType, filter: sMangaFilter, page: iMangaPage)) { response in
                self.iMangaTotal = response.pagination.items.total
                self.aryManga.append(contentsOf: response.data)
                self.aryManga = self.aryManga.sorted(by: { $0.rank < $1.rank })
            } failure: {
                
            }
        }
    }
    
    // MARK: - Private Methods
    private func reloadAnime(type: AnimeType, filter: AnimeFilter) {
        if type != sAnimeType || filter != sAnimeFilter {
            sAnimeType = type
            sAnimeFilter = filter
            iAnimePage = 0
            iAnimeTotal = -1
            aryAnime = []
            getTopAnime()
        }
    }
    
    private func reloadManga(type: MangaType, filter: MangaFilter) {
        if type != sMangaType || filter != sMangaFilter {
            sMangaType = type
            sMangaFilter = filter
            iMangaPage = 0
            iMangaTotal = -1
            aryManga = []
            getTopManga()
        }
    }
    
    // MARK: - Public Methods
    func reladView() {
        cvAnime.reladCurrentView()
        cvManga.reladCurrentView()
    }
}

extension TAAnimeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentType == .anime {
            return aryAnime.count
        } else {
            return aryManga.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.cvAnime {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifierAnime, for: indexPath) as! TAAnimeCollectionViewCell
            
            cell.configureCell(indexPath: indexPath, rows: aryAnime)
            cell.favBlock = {
                cell.isFavorite == false
                ? TACore.shared.addFavorite(type: .anime, anime: self.aryAnime[indexPath.row], manga: nil)
                : TACore.shared.removeFavorite(type: .anime, malId: cell.malId)
            }
            
            if indexPath.row == aryAnime.count - 1 {
                getTopAnime()
            }
            
            return cell
        }
        
        if collectionView == self.cvManga {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifierManga, for: indexPath) as! TAMangaCollectionViewCell
            
            cell.configureCell(indexPath: indexPath, rows: aryManga)
            cell.favBlock = {
                cell.isFavorite == false
                ? TACore.shared.addFavorite(type: .manga, anime: nil, manga: self.aryManga[indexPath.row])
                : TACore.shared.removeFavorite(type: .manga, malId: cell.malId)
            }
            
            if indexPath.row == aryManga.count - 1 {
                getTopManga()
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wt = collectionView.frame.width
        let ht = wt*(321/225)
        return CGSize(width: wt, height: ht/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var urlString = ""
        
        if collectionView == self.cvAnime {
            urlString = aryAnime[indexPath.row].url
        } else {
            urlString = aryManga[indexPath.row].url
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        present(safari, animated: true, completion: nil)
    }
}


