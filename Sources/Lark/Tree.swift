import Peek

public indirect enum Tree<Key, Leaf> where Key: Hashable {
    case leaf(Leaf)
    case array([Tree])
    case dictionary([Key: Tree])
}
    
extension Tree {
    
    public static var empty: Tree { .dictionary([:]) }
    
    public init() { self = .empty }
}

extension Tree: ExpressibleByNilLiteral {
    @inlinable public init(nilLiteral: ()) { self.init() }
}

extension Tree: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Tree...) { self = .array(elements) }
}

extension Tree: ExpressibleByDictionaryLiteral {
    @inlinable public init(dictionaryLiteral elements: (Key, Tree)...) { self = .dictionary(.init(uniqueKeysWithValues: elements)) }
}

extension Tree {
    
    public var any: Any {
        switch self {
        case let .leaf(o): return o
        case let .array(o): return o
        case let .dictionary(o): return o
        }
    }
    
    public func cast<T>(
        to: T.Type = T.self,
        function: String = #function,
        file: String = #file,
        line: Int = #line
    ) throws -> T {
        guard let t = any as? T else {
            throw Error("\(any) is not \(T.self)", function, file, line)
        }
        return t
    }
}

extension Tree {
    
    public init(_ value: Any) throws {
        throw Error()
    }
}

extension Tree {
    
    public typealias Index = EitherType<Int, Key>
    
    @inlinable public subscript(path: Index..., default o: Self) -> Self {
        self[path] ?? o
    }

    @inlinable public subscript(path: Index...) -> Self? {
        get { self[path] }
        set { self[path] = newValue }
    }
    
    @inlinable public subscript<Path>(path: Path, default o: Self) -> Self
    where Path: Collection, Path.Element == Index
    {
        self[path] ?? o
    }
    
    public subscript<Path>(path: Path) -> Self?
    where Path: Collection, Path.Element == Index
    {
        get {
            guard let first = path.first else { return self }
            switch self
            {
            case .leaf:
                return self
                
            case let .array(o):
                guard let i = first[Int.self], o.indices.contains(i) else {
                    return nil
                }
                return o[i][path.dropFirst()]
                
            case let .dictionary(o):
                guard let key = first[Key.self] else {
                    return nil
                }
                return o[key]?[path.dropFirst()]
            }
        }
        set {
            guard !path.isEmpty else {
                self = newValue ?? .empty
                return
            }
        }
    }
}

extension Tree: Equatable where Leaf: Equatable {
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.leaf(l), .leaf(r)): return l == r
        case let (.array(l), .array(r)): return l == r
        case let (.dictionary(l), .dictionary(r)): return l == r
        default: return false
        }
    }
}

extension Tree {
    
    public struct Error: Swift.Error, CustomStringConvertible, CustomDebugStringConvertible {
        public var description: String
        @inlinable public var debugDescription: String { description }
        @inlinable init(
            _ description: String = "",
            _ function: String = #function,
            _ file: String = #file,
            _ line: Int = #line
        ){
            self.description = "Tree.Error(\(description) at: \(CodeLocation(function, file, line)))"
        }
    }
}