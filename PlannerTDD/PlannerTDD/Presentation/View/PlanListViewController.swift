//
//  PlanListViewController.swift
//  PlannerTDD
//
//  Created by Gundy on 2/9/24.
//

import UIKit

final class PlanListViewController: UIViewController {
    
    typealias CellRegistration = UICollectionView.CellRegistration<PlanCell, PlannerViewModel.Content>
    typealias DataSource = UICollectionViewDiffableDataSource<State, PlannerViewModel.Content>
    typealias Snapshot = NSDiffableDataSourceSnapshot<State, PlannerViewModel.Content>
    
    private let viewModel: PlannerViewModel
    private var collectionView: UICollectionView!
    private var dataSource: DataSource?
    private var ids = [Int : [UUID]]()
    
    init(viewModel: PlannerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureCollectionView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: planLayout()
        )
        collectionView.isPagingEnabled = true
        collectionView.register(
            PlanCell.self,
            forCellWithReuseIdentifier: PlanCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func planLayout() -> UICollectionViewLayout {
        let sectionProvider = {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let layoutSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: layoutSize)
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: layoutSize,
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: containerGroup)
            
            section.orthogonalScrollingBehavior = .continuous
            
            return section
        }
        let configuration = UICollectionViewCompositionalLayoutConfiguration(scrollDirection: .horizontal)
        
        return UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: configuration
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewHierarchy()
        configureLayoutConstraint()
        configureNavigationBar()
        configureDataSource()
        bindData()
    }
    
    private func configureViewHierarchy() {
        view.addSubview(collectionView)
    }
    
    private func configureLayoutConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func configureNavigationBar() {
        navigationItem.title = State(rawValue: 0)?.name
    }
    
    private func configureDataSource() {
        let cellRegistration = CellRegistration { (cell, indexPath, content) in
            cell.configure(
                title: content.title,
                description: content.description,
                deadline: content.deadline,
                isOverdue: content.isOverdue
            )
        }
        
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, content: PlannerViewModel.Content) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: content
            )
        }
        
        configureSnapshot()
    }
    
    private func configureSnapshot() {
        var snapshot = Snapshot()
        
        snapshot.appendSections(State.allCases)
        State.allCases.forEach {
            snapshot.appendItems(
                viewModel.fetchContents(of: $0),
                toSection: $0
            )
        }
        dataSource?.apply(snapshot)
    }
    
    private func bindData() {
        viewModel.listHandler = {
            self.configureSnapshot()
        }
    }
}

extension PlanListViewController: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let remainder = scrollView.contentOffset.x.truncatingRemainder(
            dividingBy: view.frame.width
        )
        var section = Int(scrollView.contentOffset.x / view.frame.width)
        
        if remainder > view.frame.width / 2,
           section < State.allCases.count-1 {
            section += 1
        }
        
        navigationItem.title = State(rawValue: section)?.name
    }
}
