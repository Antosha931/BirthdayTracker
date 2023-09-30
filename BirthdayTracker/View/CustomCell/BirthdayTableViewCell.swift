//
//  BirthdayTableViewCell.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 24.09.2023.
//

import UIKit
import SnapKit

final class BirthdayTableViewCell: UITableViewCell {
    
    private let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Anton"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    private let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Titov"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "09.02.1993"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(firstNameLabel)
        self.contentView.addSubview(lastNameLabel)
        self.contentView.addSubview(dateLabel)
        
        firstNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentView.snp.leading).offset(15)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(firstNameLabel.snp.trailing).offset(5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
    }

    
    func configureCell(birthday: Birthday) {
        firstNameLabel.text = birthday.firstName
        lastNameLabel.text = birthday.lastName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        guard let birthday = birthday.dateOfBirth else { return }
        dateLabel.text = formatter.string(from: birthday)
    }
}
