import Foundation
import UIKit.UIImage

protocol ItemWithImage: Equatable {
    var image: UIImage? { get set }
    var urlToImage: URL? { get }
}

struct Article: Identifiable, ItemWithImage, Equatable {
    var id: UUID
    let url: URL?
    let source: String?
    let title: String
    let text: String?
    var image: UIImage?
    let date: Date?
    var urlToImage: URL?
    init(id: UUID, url: URL?, source: String?, title: String, text: String?, image: UIImage? = nil, date: Date?, urlToImage: URL? = nil) {
        self.id = id
        self.url = url
        self.source = source
        self.title = title
        self.text = text
        self.image = image
        self.date = date
        self.urlToImage = urlToImage
    }
}

struct Activity: Equatable {
    static func == (lhs: Activity, rhs: Activity) -> Bool {
        switch lhs.type {
        case .openDetail(let url):
            switch rhs.type {
            case .openDetail(let url2):
                return url == url2 && lhs.timestamp == rhs.timestamp
            default: return false
            }
        case .openURL(let url):
            switch rhs.type {
            case .openURL(let url2):
                return url == url2 && lhs.timestamp == rhs.timestamp
            default: return false
            }
        }
    }
    
    let timestamp: Date
    let type: ActivityType
    
    enum ActivityType {
        case openDetail(URL)
        case openURL(URL)
    }
}

struct NewsListItem: Identifiable {
    let id: UUID
    let title: String
    let image: UIImage?
    
    init(from article: Article) {
        self.id = article.id
        self.title = article.title
        self.image = article.image
    }
}

struct Source: Identifiable, Equatable {
    let id: UUID
    let name: String
    let category: String?
    let language: String?
    let country: String?
    let include: Bool
    let requestId: String
    init(_ source: NetworkSource) {
        self.id = UUID()
        self.name = source.name ?? self.id.uuidString
        self.category = source.category
        self.language = source.language
        self.country = source.country
        self.include = false
        self.requestId = source.id ?? ""
    }
    init(_ source: Source, include: Bool) {
        self.country = source.country
        self.language = source.language
        self.category = source.category
        self.id = source.id
        self.name = source.name
        self.include = include
        self.requestId = source.requestId
    }
}
