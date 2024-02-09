//
//  PlanCell.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

final class PlanCell: UICollectionViewCell {
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .headline)
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 3
        label.textColor = .systemGray
        label.setContentCompressionResistancePriority(.required,
                                                      for: .vertical)
        
        return label
    }()
    private let deadlineLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .callout)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        backgroundColor = .systemGray5
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
    
    func configure(title: String, description: String, deadline: String, isOverdue: Bool = false) {
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
