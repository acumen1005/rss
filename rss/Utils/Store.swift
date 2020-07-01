//
//  Store.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import SwiftUI
import Combine

typealias Store<State> = CurrentValueSubject<State, Never>

extension Store {
    
    subscript<T>(keyPath:  WritableKeyPath<Output, T>) -> T where T: Equatable {
        get { value[keyPath: keyPath] }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath:keyPath] = newValue
                self.value = value
            }
        }
    }
    
    func updates<Value>(for keyPath: KeyPath<Output, Value>) ->
        AnyPublisher<Value, Failure> where Value: Equatable {
        return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }
}

extension Binding where Value: Equatable {
    func dispatched<State>(to state: Store<State>,
                           _ keyPath: WritableKeyPath<State, Value>) -> Self {
        return onSet { state[keyPath] = $0 }
    }
}

extension Binding {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            self.wrappedValue = value
            perform(value)
        })
    }
}
