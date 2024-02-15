//
//  SetupView.swift
//  TZ clock
//
//  Created by Paulo  Henrique on 14/01/24.
//
import SwiftUI

struct SetupView: View {
    @State private var timeZone = "Brasília (GMT-2)"
    @State public var selectedOption: String = "America/Detroit";
    @State private var isPickerVisible: Bool = false

    @State public var userInput: String = ""
    @EnvironmentObject var appState: AppState

    var body: some View {
            List {
                HStack {
                    Text("Time Zone")
                        .font(.headline)
                        .listRowSeparator(.hidden)
                    
                    Spacer()
                    
                    Picker("", selection: $selectedOption) {
                        ForEach(TimeZone.knownTimeZoneIdentifiers, id: \.self) { timezone in
                            Text(timezone).tag(timezone)
                        }
                    }
                    .frame(width: 150)
                    .pickerStyle(DefaultPickerStyle())
                    .onChange(of: selectedOption) {
                        appState.updateCurrentDateTime()
                        appState.selectedTimeZone = selectedOption
                        saveAppState()
                    }
                }
                .onTapGesture {
                    isPickerVisible.toggle();
                }
                .padding(5)
                .listRowSeparator(.hidden)
                
                
                HStack {
                    Text("Clock Name")
                        .font(.headline)
                        .listRowSeparator(.hidden)
                    
                    Spacer()
                    TextField("E.g: Brazil🇧🇷", text: $userInput)
                        .onChange(of: userInput) {
                            appState.prefix = userInput
                            saveAppState()
                        }
                        .padding(2)
                        .font(.headline)
                        .frame(width:130, height:20, alignment:.trailing)
                        .cornerRadius(5)
                        .onAppear {
                            appState.updateCurrentDateTime()
                            restoreAppState()
                        }
                    
                }
                .padding(5)
                .listRowSeparator(.hidden)
                
                Divider()
                Text("Quit")
                    .font(.headline)
                    .listRowSeparator(.hidden)
                    .padding(5)
                    .keyboardShortcut("q")
                    .onTapGesture {
                        appState.quitApp()
                    }               
            }
            .navigationTitle("Settings")
            .listStyle(PlainListStyle())
            .frame(width: 350, height: 135)
            .cornerRadius(15)
            .padding(10)
        }
    
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    func saveAppState() {
        let defaults = UserDefaults.standard
        defaults.set(selectedOption, forKey: "LastSelectedTimeZone")
        defaults.set(userInput, forKey: "LastUserInput")
        defaults.synchronize()
    }
        
    public func restoreAppState() {
        let defaults = UserDefaults.standard
        if let lastSelectedTimeZone = defaults.string(forKey: "LastSelectedTimeZone") {
            selectedOption = lastSelectedTimeZone
            appState.selectedTimeZone = lastSelectedTimeZone
        }
        if let lastUserInput = defaults.string(forKey: "LastUserInput") {
            userInput = lastUserInput
            appState.prefix = lastUserInput
        }
    }
}

