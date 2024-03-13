//
//  BeerCell.swift
//  BeerApp
//
//  Created by Богдан Бончев on 10.03.2024.
//

import UIKit

class BeerCell: UITableViewCell {
    
    //MARK: Computer properties
    
    private var  imageString = "" {
        didSet {
            cunfigureImage(url: imageString)
        }
    }
    
    //MARK: Private properties
    
    private let imageBackground: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.systemOrange.cgColor
        image.alpha = 0.7
        return image
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private var abvLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
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
    
    private var brewedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private var imageBeerView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .clear
        return image
    }()
    
    //MARK: Private function
    
    private func cunfigureImage(url: String){
        if let image = StorageManager.shared.images[url] {
            imageBeerView.image = image
            return
        }
        guard let urlString = URL(string: url) else {return}
        URLSession.shared.dataTask(with: urlString) { data, _, error in
            if let error {
                print(error.localizedDescription)
                return
            }
            guard let data else { 
                StorageManager.shared.saveImage(nil, forKey: url)
                return  }
            let image = UIImage(data: data)
            StorageManager.shared.saveImage(image, forKey: url)
            DispatchQueue.main.async {
                self.imageBeerView.image = image
            }
        }.resume()
    }
    
    //MARK: Open functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageBeerView.image = nil
    }
    
    func setupUI(beer: Beer, currentMode: MainViewController.SortingMode){
        switch currentMode{
        case .all:
            nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
            abvLabel.font = .systemFont(ofSize: 15, weight: .medium)
            brewedLabel.font = .systemFont(ofSize: 15, weight: .medium)
        case .id:
            nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
            abvLabel.font = .systemFont(ofSize: 15, weight: .medium)
            brewedLabel.font = .systemFont(ofSize: 15, weight: .medium)
        case .abv:
            nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
            abvLabel.font = .systemFont(ofSize: 20, weight: .bold)
            brewedLabel.font = .systemFont(ofSize: 15, weight: .medium)

        case .date:
            nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
            abvLabel.font = .systemFont(ofSize: 15, weight: .medium)
            brewedLabel.font = .systemFont(ofSize: 20, weight: .bold)
        }
        self.nameLabel.text = beer.name
        self.abvLabel.text = "Крепкость: " + String(beer.abv)
        self.brewedLabel.text = "Дата первого приготовления: " + beer.firstBrewed
        self.imageString = beer.imageURL
    }
    
    //MARK: Initianal
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        applyConstraints()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Addsubviews
    
    private func addSubViews(){
        contentView.addSubview(imageBackground)
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageBeerView)
        contentView.addSubview(abvLabel)
        contentView.addSubview(brewedLabel)
    }
    
    //MARK: ApplyContraints
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            
            imageBackground.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            imageBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            imageBackground.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            imageBeerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 15),
            imageBeerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -8),
            imageBeerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            imageBeerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: imageBeerView.leadingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: abvLabel.topAnchor, constant: -10),
            
            abvLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            abvLabel.trailingAnchor.constraint(equalTo: imageBeerView.leadingAnchor,constant: -10),
            abvLabel.bottomAnchor.constraint(equalTo: brewedLabel.topAnchor,constant: -10),
            
            brewedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            brewedLabel.trailingAnchor.constraint(equalTo: imageBeerView.leadingAnchor,constant: -10),
            brewedLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            
        ])
    }
}
