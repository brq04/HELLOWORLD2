import SwiftUI
import UIKit
import Foundation
import Combine
@main
struct LearningApp: App {
    @StateObject private var store = LearningStore()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            rootView
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { _, newPhase in                    if newPhase == .active { store.refresh() }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
                    store.refresh()
                }
        }
    }

    @ViewBuilder
    private var rootView: some View {
        if store.goal == nil {
            OnboardingView(store: store)
        } else {
            NavigationStack {
                ActivityView(store: store)
            }
        }
    }
}
