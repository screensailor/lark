@dynamicMemberLookup
final public class Buffered<Value> {
    
    @usableFromInline
    var __o: (Value, Value)
    
    @inlinable
    public init(_ value: Value) { __o = (value, value) }
}

extension Buffered {
    
    @inlinable
    public var committed: Buffered {
        .init(__o.1)
    }
    
    @inlinable
    @discardableResult
    public func commit() -> Value {
        __o = (__o.1, __o.1)
        return __o.0
    }
}

extension Buffered {
    
    @inlinable
    public subscript<A>(dynamicMember keyPath: WritableKeyPath<Value, A>) -> A {
        get { __o.0[keyPath: keyPath] }
        set { __o.1[keyPath: keyPath] = newValue }
    }
    
    @inlinable
    public subscript() -> Value {
        get { __o.0 }
        set { __o.1 = newValue }
    }
}

extension Buffered: Equatable where Value: Equatable {
    
    @inlinable
    public static func == (lhs: Buffered<Value>, rhs: Buffered<Value>) -> Bool {
        lhs.__o == rhs.__o
    }
}

extension Buffered: CustomDebugStringConvertible {
    
    @inlinable
    public var debugDescription: String {
        "\(Buffered.self)\(__o)"
    }
}
