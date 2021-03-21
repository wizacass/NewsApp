import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var communicator: NewsCommunicator!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initialize()

        return true
    }

    private func initialize() {
        guard let apiKey: String = try? Configuration.value(for: .apiKey) else {
            NSLog("API key is missing from info.plist file!")
            exit(-1)
        }

        let parser = JsonParser()
        let apiClient = NewsApiClient(apiKey, parser)

        communicator = NewsCommunicator(apiClient)
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) { }
}
