//
//  InfoController.swift
//  BeerApp
//
//  Created by Богдан Бончев on 11.03.2024.
//

import UIKit

class InfoController: UIViewController {
    
    //MARK: Properties
    
    var beer: Beer
    
    //MARK: Private properties
    
    private var imageString = "" {
        didSet {
            cunfigureImageBeer(url: imageString)
        }
    }
    
    private let imageBackground: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "info")
        image.alpha = 0.3
        return image
    }()
    
    private var imageBeerView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var foodPairingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.text = "Сочетается с: "
        return label
    }()
    
    //MARK: Private functions
    
    private func configureUI(){
        self.nameLabel.text = beer.name
        self.descriptionLabel.text = beer.description
        self.imageString = beer.imageURL
        
        for index in beer.foodPairing {
            self.foodPairingLabel.text! += " \(index),"
        }
    }
    
    private func cunfigureImageBeer(url: String){
        guard let urlString = URL(string: url) else {return}
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageBeerView.image = image
            }
        }.resume()
    }
    
    //MARK: Initianal
    
    init(beer: Beer) {
        self.beer = beer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cicle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        applyConstraints()
        configureUI()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: Addsubviews
    
    private func addSubViews(){
        view.addSubview(imageBackground)
        view.addSubview(imageBeerView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(foodPairingLabel)
    }
    
    //MARK: Constraints
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            
            imageBackground.topAnchor.constraint(equalTo: view.topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageBeerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 30),
            imageBeerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageBeerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            imageBeerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: imageBeerView.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
            foodPairingLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            foodPairingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            foodPairingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            
        ])
    }
}
