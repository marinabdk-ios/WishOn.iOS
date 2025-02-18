//
//  WishOnApp.swift
//  WishOn
//
//  Created by Mari Budko on 26.11.2024.
//

import SwiftUI
import FirebaseCore


@main
struct WishOnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var wishListVM: WishListViewModel
    
    let persistenceController = PersistenceController.shared
    
    init() {
        FirebaseApp.configure()
//    #if DEBUG
//            WishOnApp.unitTestConfig()
//    #else
        DIRepositoriesContainer.shared.register(repository: WishListRepository() as WishListRepositoryProtocol)
    //#endif
        
        _wishListVM = StateObject(
            wrappedValue: WishListViewModel()
        )
    }
    
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(wishListVM)
                .environment(
                    \.managedObjectContext,
                     persistenceController.container.viewContext
                )
        }
    }
    
    
#if DEBUG
    static func unitTestConfig() {
        if CommandLine.arguments.contains(UnitTestsCaseConstants.emptyList) {
            DIRepositoriesContainer.shared.register(repository: MockWishListEmptyRepository() as WishListRepositoryProtocol)
        } else {
            DIRepositoriesContainer.shared.register(repository: MockWishListRepository() as WishListRepositoryProtocol)
        }
    }
#endif

}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
   // FirebaseApp.configure()

    return true
  }
}
