public protocol BaseEntity: Codable {
    associatedtype Model
    func toModel() -> Model
}
