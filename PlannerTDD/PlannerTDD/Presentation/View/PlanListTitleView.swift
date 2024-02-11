//
//  PlanListTitleView.swift
//  PlannerTDD
//
//  Created by Gundy on 2/11/24.
//

import UIKit

final class PlanListTitleView: UIView {
    
    private let stackView = UIStackView(
        axis: .horizontal,
        spacing: 4,
        alignment: .center,
        translatesAutoresizingMaskIntoConstraints: false
    )
    private let titleLabel = UILabel(font: .preferredFont(forTextStyle: .headline))
    private let countLabel = RoundedLabel(
        circleColor: .label,
        textColor: .systemBackground
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
        [titleLabel, countLabel].forEach { stackView.addArrangedSubview($0) }
        addSubview(stackView)
    }
    
    private func configureLayoutConstraint() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            countLabel.widthAnchor.constraint(greaterThanOrEqualTo: countLabel.heightAnchor)
        ])
    }
    
    func setContents(title: String?, count: Int) {
        titleLabel.text = title
        countLabel.text = count > 100 ? "100+" : String(count)
    }
}
