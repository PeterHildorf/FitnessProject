
import FirebaseAuth

protocol UserProtocol {
    var uid: String { get }
}

extension FirebaseAuth.User: UserProtocol {}
