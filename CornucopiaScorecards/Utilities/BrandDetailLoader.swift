import Foundation

enum BrandDetailLoader {
    private static var cache: [String: [String: BrandDetail]] = [:]

    static func loadDetails(for category: ScorecardCategory) -> [String: BrandDetail] {
        if let cached = cache[category.csvFileName] {
            return cached
        }

        guard let url = Bundle.main.url(forResource: category.detailsFileName, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let details = try? JSONDecoder().decode([BrandDetail].self, from: data) else {
            cache[category.csvFileName] = [:]
            return [:]
        }

        let dict = Dictionary(details.map { ($0.name, $0) }, uniquingKeysWith: { first, _ in first })
        cache[category.csvFileName] = dict
        return dict
    }

    static func detail(for brandName: String, in category: ScorecardCategory) -> BrandDetail? {
        loadDetails(for: category)[brandName]
    }
}
