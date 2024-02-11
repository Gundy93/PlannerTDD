//
//  PlanCell.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

final class PlanCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "PlanCell"
    
    private let stackView = UIStackView(
        axis: .vertical,
        spacing: 8,
        distribution: .fillProportionally,
        translatesAutoresizingMaskIntoConstraints: false
    )
    private let titleLabel = UILabel(
        font: .preferredFont(forTextStyle: .headline)
    )
    private let descriptionLabel = UILabel(
        font: .preferredFont(forTextStyle: .body),
        textColor: .systemGray,
        numberOfLines: 3
    )
    private let deadlineLabel = UILabel(
        font: .preferredFont(forTextStyle: .callout)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViewHierarchy()
        configureLayoutConstraint()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewHierarchy() {
        [titleLabel, descriptionLabel, deadlineLabel].forEach { stackView.addArrangedSubview($0) }
        contentView.addSubview(stackView)
    }
    
    private func configureLayoutConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
    
    func configure(title: String, description: String, deadline: String, isOverdue: Bool) {
        setTexts(title: title, description: description, deadline: deadline)
        setDeadlineColor(isOverDue: isOverdue)
    }
    
    private func setTexts(title: String, description: String, deadline: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        deadlineLabel.text = deadline
    }
    
    private func setDeadlineColor(isOverDue: Bool) {
        deadlineLabel.textColor = isOverDue ? .systemRed : .label
    }
}
