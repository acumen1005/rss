////
////  Store.swift
////  rss
////
////  Created by 谷雷雷 on 2020/6/24.
////  Copyright © 2020 acumen. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//import Combine
//
//protocol StateType { }
//protocol Action { }
//protocol AsyncAction: Action {
//    func execute(state: StateType?, dispatch: @escaping DispatchFunction)
//}
//
//typealias DispatchFunction = (Action) -> Void
//typealias Reducer<StateType> = (_ state: StateType, _ action: Action) -> StateType
//typealias Middleware<State> = (@escaping DispatchFunction, @escaping () -> StateType?) -> (@escaping DispatchFunction) -> DispatchFunction
//
//class Store<StoreState: StateType>: ObservableObject {
//
//    @Published var state: StoreState
//
//    private let reducer: Reducer<StoreState>
//
//    init(reducer: @escaping Reducer<StoreState>,
//         state: StoreState) {
//        self.reducer = reducer
//        self.state = state
//    }
//
//    func dispatch(action: Action) {
//        self._dispatch(action: action)
//    }
//
//    private func _dispatch(action: Action) {
//        state = reducer(state, action)
//    }
//}
//
////struct StoreConnector<StoreState: StateType, V: View>: View {
////    @EnvironmentObject var store: Store<StoreState>
////    let content: (StoreState, @escaping (Action) -> Void) -> V
////
////    public var body: V {
////        content(store.state, store.dispatch(action:))
////    }
////}
////
////protocol ConnectedView: View {
////    associatedtype StoreState: StateType
////    associatedtype Props
////    associatedtype V: View
////
////    func map(state: StoreState, dispatch: @escaping DispatchFunction) -> Props
////    func body(props: Props) -> V
////}
////
////extension ConnectedView {
////    func render(state: StoreState, dispatch: @escaping DispatchFunction) -> V {
////        let props = map(state: state, dispatch: dispatch)
////        return body(props: props)
////    }
////
////    var body: StoreConnector<StoreState, V> {
////        return StoreConnector(content: render)
////    }
////}
//
//
