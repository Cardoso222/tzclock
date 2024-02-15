//
//  TopBarView.swift
//  TZ clock
import SwiftUI

@main
struct TopBarApp: App {
    @StateObject private var appState = AppState();
    var body: some Scene {
        MenuBarExtra("🌎 " + appState.prefix + " " + appState.currentDateTime) {
            SetupView().environmentObject(appState)
        }.menuBarExtraStyle(WindowMenuBarExtraStyle())
    }
}


class AppState: ObservableObject {
    init() {
        self.prefix = UserDefaults.standard.string(forKey: "LastUserInput") ?? "<clock name>"
        self.selectedTimeZone = UserDefaults.standard.string(forKey: "LastSelectedTimeZone") ?? "America/Detroit"
        
        updateCurrentDateTime()
        startTimer()
    }
    
    let defaults = UserDefaults.standard

    @Published var prefix: String;
    @Published var selectedTimeZone: String;
    @Published var currentDateTime: String = ""

    func updateCurrentDateTime() {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: self.selectedTimeZone)
        formatter.dateFormat = "HH:mm"
        self.currentDateTime = formatter.string(from: Date())
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.updateCurrentDateTime()
        }
    }
    
    func quitApp() {
         exit(0)
     }
}
