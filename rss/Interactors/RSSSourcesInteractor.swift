//
//  RSSSourcesInteractor.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

protocol RSSSourcesInteractor {
    
    func load(sources: Binding<[RSS]>)
    func store(source: RSS)
    func store(url: String, title: String?, desc: String?)
}

struct RealRSSSourcesInteractor: RSSSourcesInteractor {
    
    let dbRepository: RSSSourcesDBRepository
    let appState: Store<AppState>
    
    func load(sources: Binding<[RSS]>) {
        let cancelBag = CancelBag()
        dbRepository.sources().sink(receiveCompletion: { subscriptionCompletion in
            if case Subscribers.Completion.failure(let error) = subscriptionCompletion {
                print("error = \(error)")
            }
        }, receiveValue: { value in
            sources.wrappedValue = value
        })
        .store(in: cancelBag)
    }
    
    func store(url: String, title: String?, desc: String?) {
        let cancelBag = CancelBag()
        dbRepository.store(url: url, title: title, desc: desc).sink(receiveCompletion: { subscriptionCompletion in
            if case Subscribers.Completion.failure(let error) = subscriptionCompletion {
                print("error = \(error)")
            }
        }, receiveValue: {
        })
        .store(in: cancelBag)
    }
    
    func store(source: RSS) {
        let cancelBag = CancelBag()
        dbRepository.store(sources: [source]).sink(receiveCompletion: { subscriptionCompletion in
            if case Subscribers.Completion.failure(let error) = subscriptionCompletion {
                print("error = \(error)")
            }
        }, receiveValue: {
        })
        .store(in: cancelBag)
    }
}

struct SubRSSSourcesInteractor: RSSSourcesInteractor {
    func load(sources: Binding<[RSS]>) {
    }
    
    func store(source: RSS) {
        
    }
    
    func store(url: String, title: String?, desc: String?) {
        
    }
}
