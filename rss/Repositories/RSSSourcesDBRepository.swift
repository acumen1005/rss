//
//  RSSSourceDBRepository.swift
//  rss
//
//  Created by 谷雷雷 on 2020/7/1.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation
import CoreData
import Combine

protocol RSSSourcesDBRepository {
    func hasLoadedCountries() -> AnyPublisher<Bool, Error>
    func sources() -> AnyPublisher<Array<RSS>, Error>
    func store(sources: [RSS]) -> AnyPublisher<Void, Error>
    
    func store(url: String, title: String?, desc: String?) -> AnyPublisher<Void, Error>
}

struct RealRSSSourcesDBRepository: RSSSourcesDBRepository {
    
    let persistentStore: PersistentStore
    
    func hasLoadedCountries() -> AnyPublisher<Bool, Error> {
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        return persistentStore
            .count(fetchRequest)
            .map { $0 > 0 }
            .eraseToAnyPublisher()
    }
    
    func sources() -> AnyPublisher<Array<RSS>, Error> {
        let fetchRequest: NSFetchRequest<RSS> = RSS.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createTime", ascending: false)]
        return persistentStore
            .fetch(fetchRequest) { $0 }
            .eraseToAnyPublisher()
    }
    
    func store(sources: [RSS]) -> AnyPublisher<Void, Error> {
        let cancelBag = CancelBag()
        return persistentStore
            .update { context in
                sources.forEach {
                    $0.store(in: context)
                    fetchNewRSS(model: $0).sink(receiveCompletion: { subscriptionCompletion in
                        if case Subscribers.Completion.failure(let error) = subscriptionCompletion {
                            print("error = \(error)")
                        }
                    }, receiveValue: { value in
                        print("value = \(value)")
                    })
                    .store(in: cancelBag)
                }
        }
    }
    
    func store(url: String, title: String?, desc: String?) -> AnyPublisher<Void, Error> {
        return persistentStore
            .update { context in
                RSS.create(url: url, title: title, desc: desc, in: context)
            }
    }
}
