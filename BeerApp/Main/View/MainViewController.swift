//
//  MainViewController.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

class MainViewController: UIViewController {

    enum SortingMode: Int, CaseIterable {
        case all
        case id
        case abv
        case date
        
        var title: String {
            switch self {
            case .all:
                return "Все"
            case .id:
                return "По номеру"
            case .abv:
                return "По крепости"
            case .date:
                return "По дате"
            }
        }
    }
    
    //MARK: Private properties
    
    private var currentMode: SortingMode = .all {
        didSet {
            guard oldValue != currentMode else {return}
            beerTableView.reloadData()
        }
    }
    
    private let defaultCellHeight: CGFloat = 150.0
    private var timer = Timer()
    private var countBeer = 19
    private var pageNumber = 1
    
    private var searchBeer = [Beer](){
        didSet{
            self.beerTableView.reloadData()
            print("searchBeer " + String(self.searchBeer.count))
        }
    }
    
    private var beers = [Beer]() {
        didSet {
            DispatchQueue.main.async {
                self.beerTableView.reloadData()
                print("beers " + String(self.beers.count))
            }
        }
    }
    
    private var beerPresenter: BeerPresenterProtocol
    
    private var searchIsEmpty: Bool{
        guard let text = searchBar.searchBar.text else {return true}
        return text.isEmpty
    }
    
    private var searchIsWorking: Bool {
        return searchBar.isActive && !searchIsEmpty
    }
    
    private let imageBackground: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "main")
        image.alpha = 0.3
        return image
    }()
    
    private lazy var loadingView: UIView = {
        let image = UIView(frame: CGRect(origin: .zero,
                                         size: CGSize(width: UIScreen.main.bounds.width,
                                                      height: defaultCellHeight)))
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .systemOrange
        image.addSubview(indicator)
        indicator.center = image.center
        indicator.startAnimating()
        image.isHidden = true
        return image
    }()
    
    private lazy var searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.placeholder = "Поиск"
        search.searchBar.delegate = self
        search.searchBar.tintColor = .systemOrange
        search.searchBar.layer.cornerRadius = 20
        search.searchBar.searchTextField.textColor = .systemOrange
        search.searchBar.searchTextField.backgroundColor = .lightGray
        return search
    }()
    
    private lazy var beerSegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: SortingMode.allCases.map{ $0.title })
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = currentMode.rawValue
        segment.backgroundColor = .systemOrange
        segment.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var beerTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.delegate = self
        table.dataSource = self
        table.register(BeerCell.self, forCellReuseIdentifier: BeerCell.reuseId)
        table.tableFooterView = loadingView
        return table
    }()
    
    //MARK: Private functions
    
    //MARK: Initianal
    
    init(beerPresenter: BeerPresenterProtocol) {
        self.beerPresenter = beerPresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        addSubViews()
        applyConstraints()
        navigationItem.searchController = searchBar
        beerPresenter.fetchBeer(page: 1)
    }
    
    //MARK: AddSubViews
    
    private func addSubViews(){
        
        view.addSubview(imageBackground)
        view.addSubview(beerSegment)
        view.addSubview(beerTableView)
    }
    
    //MARK: Constraints
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            
            imageBackground.topAnchor.constraint(equalTo: view.topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            beerSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            beerSegment.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            beerSegment.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            beerSegment.heightAnchor.constraint(equalToConstant: 25),
            
            beerTableView.topAnchor.constraint(equalTo: beerSegment.bottomAnchor,constant: 10),
            beerTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            beerTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            beerTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    //MARK: Actions
    
    @objc func loadMoreData(){
        self.pageNumber += 1
        self.beerPresenter.fetchBeer(page: self.pageNumber)
    }
    @objc func indexChanged(_ segmentControl: UISegmentedControl ){
        guard let mode = SortingMode(rawValue: segmentControl.selectedSegmentIndex) else { return }
        currentMode = mode
    }
}

    //MARK: Extantions for table

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchIsWorking ? searchBeer.count : beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerCell.reuseId, for: indexPath) as? BeerCell else {return UITableViewCell()}
        var beers = searchIsWorking ?  searchBeer : beers
        switch currentMode {
        case .all:
            break
        case .id:
            beers = beers.sorted { $0.id < $1.id }
        case .abv:
            beers = beers.sorted { $0.abv < $1.abv }
        case .date:
            beers = beers.sorted { $0.firstBrewed < $1.firstBrewed}
        }
        let beer = beers[indexPath.row]
        cell.setupUI(beer: beer, currentMode: currentMode )
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return defaultCellHeight
//        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !searchIsWorking {
            if indexPath.row == countBeer {
                countBeer += 20
                loadMoreData()
                loadingView.isHidden = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var beers = searchIsWorking ?  searchBeer : beers
        switch currentMode {
        case .all:
            break
        case .id:
            beers = beers.sorted { $0.id < $1.id }
        case .abv:
            beers = beers.sorted { $0.abv < $1.abv }
        case .date:
            beers = beers.sorted { $0.firstBrewed < $1.firstBrewed}
        }
        let beer = beers[indexPath.row]
        let infoController = InfoController(beer: beer)
        navigationController?.pushViewController(infoController, animated: true)
    }
}

    //MARK: Extantions for protocol the beer presenter

extension MainViewController: BeerPresenterDelegate {
    
    func takeBeersSearch(beersArray: [Beer]) {
        searchBeer = beersArray
    }
    
    func takeTheBeers(beersArray: [Beer]){
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            self.beers.append(contentsOf: beersArray)
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
//        }
    }
    
    func takeTheResponce(error: NetworkError) {
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "cancel", style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

    //MARK: Extantions for search

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        guard let text = text else { return }
        if text != "" {
            timer.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.beerPresenter.fetchBeerSearch(nameBeer: text)
            })
        }
    }
}
