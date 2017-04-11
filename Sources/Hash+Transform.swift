//
//  Hash+Transform.swift
//  RbSwift
//
//  Created by Draveness on 06/04/2017.
//  Copyright © 2017 draveness. All rights reserved.
//

import Foundation

// MARK: - Transform
public extension Hash {
    /// Returns a new hash containing the contents of `otherHash` and the contents of hsh.
    /// If no block is specified, the value for entries with duplicate keys will be that 
    /// of `otherHash`. 
    ///
    ///     let h1 = ["a": 100, "b": 200]
    ///     let h2 = ["b": 254, "c": 300]
    ///
    /// 	h1.merge(h2)		#=> ["a": 100, "b": 254, "c": 300]))
    ///
    /// Otherwise the value for each duplicate key is determined by calling
    /// the block with the key, its value in hsh and its value in `otherHash`.
    ///
    /// 	h1.merge(h2) { (key, oldval, newval) in
    ///         newval - oldval
    ///     }		#=> ["a": 100, "b": 54,  "c": 300]
    ///
    /// 	h1		#=> ["a": 100, "b": 200]
    ///
    /// - Parameters:
    ///   - otherHash: Another hash instance.
    ///   - closure: A closure returns a new value if duplicate happens.
    /// - Returns: A new hash containing the contents of both hash.
    func merge(_ otherHash: Hash<Key, Value>, closure: ((Key, Value, Value) -> Value)? = nil) -> Hash<Key, Value> {
        var map = Hash<Key, Value>()
        for (k, v) in self {
            map[k] = v
        }
        for (key, value) in otherHash {
            if let oldValue = map[key],
                let closure = closure {
                map[key] = closure(key, oldValue, value)
            } else {
                map[key] = value
            }
        }
        return map
    }
    
    /// An alias to `Hash#merge(otherHash:)` methods.
    ///
    /// - Parameters:
    ///   - otherHash: Another hash instance.
    ///   - closure: A closure returns a new value if duplicate happens.
    /// - Returns: A new hash containing the contents of both hash.
    func update(_ otherHash: Hash<Key, Value>, closure: ((Key, Value, Value) -> Value)? = nil) -> Hash<Key, Value> {
        return merge(otherHash, closure: closure)
    }
    
    /// A mutating version of `Hash#merge(otherHash:closure:)`
    ///
    ///     let h1 = ["a": 100, "b": 200]
    ///     let h2 = ["b": 254, "c": 300]
    ///
    /// 	h1.merge(h2)		#=> ["a": 100, "b": 254, "c": 300]))
    /// 	h1                  #=> ["a": 100, "b": 254, "c": 300]))
    ///
    /// - Parameters:
    ///   - otherHash: Another hash instance.
    ///   - closure: A closure returns a new value if duplicate happens.
    /// - Returns: Self
    @discardableResult mutating func merged(_ otherHash: Hash<Key, Value>, closure: ((Key, Value, Value) -> Value)? = nil) -> Hash<Key, Value> {
        self = self.merge(otherHash, closure: closure)
        return self
    }
    
    /// An alias to `Hash#merged(otherHash:)` methods.
    ///
    /// - Parameters:
    ///   - otherHash: Another hash instance.
    ///   - closure: A closure returns a new value if duplicate happens.
    /// - Returns: Self
    @discardableResult mutating func updated(_ otherHash: Hash<Key, Value>, closure: ((Key, Value, Value) -> Value)? = nil) -> Hash<Key, Value> {
        return merged(otherHash, closure: closure)
    }

    /// Removes all key-value pairs from hsh.
    ///
    ///     var hash = ["a": 100]
    /// 	hash.clear()		#=> [:]
    /// 	hash                #=> [:]
    ///
    /// - Returns: Self with empty hash.
    @discardableResult mutating func clear() -> Hash<Key, Value> {
        self = [:]
        return self
    }
    
    /// An alias to `Hash#removeValue(forKey:)`.
    ///
    ///     var hash = ["a": 100, "b": 200]
    /// 	hash.delete("a")		#=> 100
    /// 	hash                    #=> ["b": 200]
    ///
    /// - Parameter key: A key of hash.
    /// - Returns: Corresponding value or nil.
    @discardableResult mutating func delete(_ key: Key) -> Value? {
        return self.removeValue(forKey: key)
    }
    
    /// Replaces the contents of hsh with the contents of otherHash.
    ///
    ///     var hash = ["a": 100, "b": 200]
    /// 	hash.replace(["c": 300])		#=> ["c": 300]
    /// 	hash                            #=> ["c": 300]
    ///
    /// - Parameter otherHash: Another hash instance.
    /// - Returns: Self
    @discardableResult mutating func replace(_ otherHash: Hash<Key, Value>) -> Hash<Key, Value> {
        self = otherHash
        return self
    }
}