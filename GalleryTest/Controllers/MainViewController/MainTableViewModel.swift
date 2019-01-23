//
//  MainTableViewModel.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 19.11.2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import UIKit

class MainTableViewModel {
    private enum ExpressionKeys: String {
        case title
    }
    
    enum State {
        case startLoading
        case downloaded
        case finishedOnError
        case searchedMatches
        
        case none
    }
    
    init(_ stateHandler: @escaping (State) -> Void) {
        self.stateHandler = stateHandler
        
        fetchData()
    }
    
    private let stateHandler: (State) -> Void
    private var imageExtractor: ImageExtractor!
    
    private var images = [Image]()
    private var filteredImages: [Image]?
    
    private(set) var loadingState: State = .none {
        didSet {
            stateHandler(loadingState)
        }
    }
    
    private var outputImages: [Image] { return filteredImages ?? images }
    var imagesCount: Int { return outputImages.count }
    
    func fetchData() {
        loadingState = .startLoading
        imageExtractor = ImageExtractor() { [weak self] images in
            if let images = images {
                self?.images = images
                self?.loadingState = .downloaded
            } else {
                self?.loadingState = .finishedOnError
            }
        }
    }
    
    func imageAtIndexPath(_ indexPath: IndexPath) -> Image? {
        let index = indexPath.row
        guard outputImages.indices.contains(index) else { return nil }
        
        return outputImages[index]
    }
    
    // MARK: - Searching
    
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        var searchItemsPredicate = [NSPredicate]()
        
        let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        let titleSearchComparisonPredicate =
            NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(titleSearchComparisonPredicate)
        
        let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        
        return orMatchPredicate
    }
    
    func searchMatchedTextTo(_ text: String) {
        let searchResults = images
        
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = text.trimmingCharacters(in: whitespaceCharacterSet)
        
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }
        let finalCompoundPredicate =
            NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        filteredImages = text.isEmpty ? nil : searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        loadingState = .searchedMatches
    }
    
}
