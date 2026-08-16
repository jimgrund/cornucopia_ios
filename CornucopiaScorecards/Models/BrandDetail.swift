import Foundation

struct BrandDetailField: Codable, Identifiable {
    let label: String
    let value: String

    var id: String { label }
}

struct BrandCriterion: Codable, Identifiable {
    let criteria: String
    let points: String
    let comment: String
    let description: String

    var id: String { criteria }
}

struct BrandDetail: Codable, Identifiable {
    let name: String
    let url: String
    let summary: String?
    let totalScore: String?
    let possibleScore: String?
    let fields: [BrandDetailField]
    let criteria: [BrandCriterion]

    var id: String { name }
}
