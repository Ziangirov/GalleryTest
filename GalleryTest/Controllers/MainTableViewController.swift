//
//  MainTableViewController.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 31/10/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

final class MainTableViewController: BaseTableViewController {
    private enum RestorationKeys: String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    private enum ExpressionKeys: String {
        case title
    }
    
    private struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    private(set) var searchController: UISearchController!
    private var resultsTableController: ResultsTableController!
    private var restoredState = SearchControllerRestorableState()
    
    private var imageExtractor: ImageExtractor!
    
    var gallery = [Image]() {
        didSet {
            DispatchQueue.main.async { self.tableView.reloadData() }
        }
    }
    
    @objc private func refreshData(_ sender: (Any?) = nil) {
        AppDelegate.cache.removeAllCachedResponses()
        fetchData()
    }
    
    private func fetchData() {
        imageExtractor = ImageExtractor() { images in
            if let images = images {
                self.gallery = images
            }
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultsTableController = ResultsTableController()
        
        resultsTableController.tableView.delegate = self
        resultsTableController.view.backgroundColor = .lead
        resultsTableController.tableView.separatorStyle = .none
        resultsTableController.tableView.rowHeight = 116
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.tintColor = .white
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if gallery.isEmpty {
            fetchData()
        }
        
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.animatedAppearing()
    }
    
}

// MARK: - UITableViewDelegate

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedImage: Image

        if tableView === self.tableView {
            selectedImage = gallery[indexPath.row]
        } else {
            selectedImage = resultsTableController.filteredImages[indexPath.row]
        }

        let detailVC = DetailViewController.detailViewControllerForImage(selectedImage)
        
        if let splitVC = splitViewController as? GallerySplitViewController {
            splitVC.showDetailViewController(detailVC, sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK: - UITableViewDataSource

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return gallery.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.reuseID, for: indexPath)
        
        let image = gallery[indexPath.row]
        configureCell(cell, forImage: image)
        
        return cell
    }
    
}

// MARK: - UISearchBarDelegate

extension MainTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - UISearchControllerDelegate

extension MainTableViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}

extension MainTableViewController: UISearchResultsUpdating {
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        var searchItemsPredicate = [NSPredicate]()
        
        let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: titleExpression,
                                  rightExpression: searchStringExpression,
                                  modifier: .direct,
                                  type: .contains,
                                  options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        
        return orMatchPredicate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = gallery
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString =
            searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }
        
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        if let resultsController = searchController.searchResultsController as? ResultsTableController {
            resultsController.filteredImages = filteredResults
            resultsController.tableView.reloadData()
        }
    }
    
}

// MARK: - UIStateRestoration

extension MainTableViewController {
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)

        coder.encode(navigationItem.title!, forKey: RestorationKeys.viewControllerTitle.rawValue)

        coder.encode(searchController.isActive, forKey: RestorationKeys.searchControllerIsActive.rawValue)
        
        coder.encode(searchController.searchBar.isFirstResponder, forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        coder.encode(searchController.searchBar.text, forKey: RestorationKeys.searchBarText.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
            fatalError("A title did not exist.")
        }
        navigationItem.title! = decodedTitle
        
        restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
  
        restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
    }
    
}
