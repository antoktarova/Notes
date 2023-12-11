import Foundation

struct Task: Equatable, Codable {
    
    enum Priority: Equatable, Codable {
        case normal
        case low
        case high
    }
    
    let id: UUID
    let title: String
    var isDone: Bool
    let priority: Priority
    var deadline: Date? = nil
}

