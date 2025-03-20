//
//  GameboardViewController.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-19.
//

import Foundation
import UIKit

protocol GameboardViewControllerDelegate: AnyObject {
    func didSelectSquare(row: Int, column: Int)
}

final class GameboardViewController: UIViewController {
    private enum Section: Hashable {
        case section(Int)
    }

    @IBOutlet weak var collectionView: UICollectionView!

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Gameboard.Square> = createDataSource()

    weak var delegate: GameboardViewControllerDelegate?

    var gameboard: Gameboard? {
        didSet {
            updateGameboard()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
        updateGameboard()
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            let contentSize = CGSize(
                width: layoutEnvironment.container.effectiveContentSize.width,
                height: layoutEnvironment.container.effectiveContentSize.height - 16
            )

            let layoutItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            ))
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(contentSize.height / 3.0)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: layoutItem,
                count: 3
            )
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            return section
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 8

        layout.configuration = configuration

        return layout
    }

    private func createDataSource() -> UICollectionViewDiffableDataSource<Section, Gameboard.Square> {
        let gameboardCellRegistration = UICollectionView.CellRegistration<GameboardCell, Gameboard.Square> { cell, indexPath, item in
            cell.item = item
        }

        return UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: gameboardCellRegistration,
                for: indexPath,
                item: item
            )
        }
    }

    private func updateGameboard() {
        guard let gameboard = gameboard, isViewLoaded else { return }
        updateSnapshot(gameboard)
    }

    private func updateSnapshot(_ gameboard: Gameboard) {
        dataSource.apply(
            createSnapshot(gameboard),
            animatingDifferences: true
        )
    }

    private func createSnapshot(_ gameboard: Gameboard) -> NSDiffableDataSourceSnapshot<Section, Gameboard.Square> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Gameboard.Square>()

        for (index, squares) in gameboard.rows.enumerated() {
            snapshot.appendSections([.section(index)])
            snapshot.appendItems(squares)
        }

        return snapshot
    }
}

extension GameboardViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectSquare(row: indexPath.section, column: indexPath.row)
    }
}
