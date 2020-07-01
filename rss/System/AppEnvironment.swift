//
//  AppEnvironment.swift
//  rss
//
//  Created by 谷雷雷 on 2020/6/30.
//  Copyright © 2020 acumen. All rights reserved.
//

import Foundation

struct AppEnvironment {
    let container: DIContainer
}

extension AppEnvironment {
    
    static func bootstrap() -> AppEnvironment {
        let appState = Store<AppState>(AppState())
        /*
         To see the deep linking in action:
         
         1. Launch the app in iOS 13.4 simulator (or newer)
         2. Subscribe on Push Notifications with "Allow Push" button
         3. Minimize the app
         4. Drag & drop "push_with_deeplink.apns" into the Simulator window
         5. Tap on the push notification
         
         Alternatively, just copy the code below before the "return" and launch:
         
            DispatchQueue.main.async {
                deepLinksHandler.open(deepLink: .showCountryFlag(alpha3Code: "AFG"))
            }
        */
//        let session = configuredURLSession()
//        let webRepositories = configuredWebRepositories(session: session)
        let dbRepositories = configuredDBRepositories(appState: appState)
        let interactors = configuredInteractors(appState: appState,
                                                dbRepositories: dbRepositories)
        let diContainer = DIContainer(appState: appState, interactors: interactors)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredDBRepositories(appState: Store<AppState>) -> DIContainer.DBRepositories {
        let persistentStore = CoreDataStack(version: CoreDataStack.Version.actual)
        let rssSourcesDBRepository = RealRSSSourcesDBRepository(persistentStore: persistentStore)
        return .init(rssSourcesRepository: rssSourcesDBRepository)
    }
    
    private static func configuredInteractors(appState: Store<AppState>,
                                              dbRepositories: DIContainer.DBRepositories
    ) -> DIContainer.Interactors {
        
        let rssSourcesInteractor = RealRSSSourcesInteractor(
            dbRepository: dbRepositories.rssSourcesRepository,
            appState: appState)
        
        return .init(rssSourcesInteractor: rssSourcesInteractor)
    }
}


extension DIContainer {
    struct WebRepositories {
        
    }
    
    struct DBRepositories {
        let rssSourcesRepository: RSSSourcesDBRepository
    }
}
