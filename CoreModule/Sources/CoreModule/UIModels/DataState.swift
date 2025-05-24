import Foundation

enum DataState<T> {
    case loading
    case error(String)
    case loaded(T)
}
