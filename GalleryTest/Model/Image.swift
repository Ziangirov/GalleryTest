//
//  Image.swift
//  GalleryTest
//
//  Created by Evgeniy Ziangirov on 31/10/2018.
//  Copyright © 2018 Evgeniy Ziangirov. All rights reserved.
//

import Foundation

final class Image: NSObject, Codable {
    private enum CodingKeys: String, CodingKey {
        case imageURL = "url"
        case thumbnailURL = "url_tn"
        case title = "name"
    }
    
    let imageURL: String
    let thumbnailURL: String
    @objc let title: String
    
    var imgURL: URL? {
        return !imageURL.isEmpty ? URL(string: imageURL) : nil
    }
    var tnURL: URL? {
        return !thumbnailURL.isEmpty ? URL(string: thumbnailURL) : nil
    }
    
    init(imageURL: String, thumbnailURL: String, title: String) {
        self.imageURL = imageURL
        self.thumbnailURL = thumbnailURL
        self.title = title
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        title = try container.decode(String.self, forKey: .title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        guard let decodedTitle = aDecoder.decodeObject(forKey: CodingKeys.title.rawValue) as? String else {
            fatalError("A title did not exist.")
        }
        title = decodedTitle
        guard let decodedImageURL = aDecoder.decodeObject(forKey: CodingKeys.imageURL.rawValue) as? String else {
            fatalError("A imageURL did not exist.")
        }
        imageURL = decodedImageURL
        guard let decodedThumbnailURL = aDecoder.decodeObject(forKey: CodingKeys.thumbnailURL.rawValue) as? String else {
            fatalError("A thumbnailURL did not exist.")
        }
        thumbnailURL = decodedThumbnailURL
    }
    
}

extension Image: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: CodingKeys.title.rawValue)
        aCoder.encode(imageURL, forKey: CodingKeys.imageURL.rawValue)
        aCoder.encode(thumbnailURL, forKey: CodingKeys.thumbnailURL.rawValue)
    }

}
