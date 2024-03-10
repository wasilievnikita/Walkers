//
//  NewUserTableViewCell.swift
//  Walkers
//
//  Created by Никита Васильев on 09.10.2023.
//

import UIKit

class NewUserTableViewCell: UITableViewCell {
        
    private var indexPathCell = IndexPath()
    
    // MARK: - UIElements
    
    private let contentWhiteView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let name: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    private let age: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "HelveticaNeue", size: 12)
        return label
    }()
    
    lazy var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    // MARK: - Funcs
    
    func setIndexPath(indexPath: IndexPath) {
        indexPathCell = indexPath
    }
    
    func setupCell(model: User) {
        name.text = model.name.first
        age.text = "Возраст:" + " " + String(model.dob.age)
      
            guard let imageData = try? Data(contentsOf: model.picture.medium) else {fatalError()}
            photo.image = UIImage(data: imageData)!
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func addViews() {
        contentView.addSubview(contentWhiteView)
        contentWhiteView.addSubview(name)
        contentWhiteView.addSubview(age)
        contentWhiteView.addSubview(photo)
        layout()
    }
    
    private func layout() {
        
        let inset: CGFloat = 20
        
        NSLayoutConstraint.activate([
            
            contentWhiteView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentWhiteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentWhiteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentWhiteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            name.topAnchor.constraint(equalTo: contentWhiteView.topAnchor, constant: inset / 2),
            name.leadingAnchor.constraint(equalTo: photo.trailingAnchor, constant:  inset),
            
            age.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            age.topAnchor.constraint(equalTo: name.bottomAnchor, constant: inset / 2),
            age.bottomAnchor.constraint(equalTo: contentWhiteView.bottomAnchor, constant: -inset / 2),
            
            photo.leadingAnchor.constraint(equalTo: contentWhiteView.leadingAnchor, constant: inset),
            photo.topAnchor.constraint(equalTo: name.topAnchor),
            photo.bottomAnchor.constraint(equalTo: contentWhiteView.bottomAnchor, constant: -inset / 2),
            
        ])
    }
}
