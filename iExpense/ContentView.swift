//
//  ContentView.swift
//  iExpense
//
//  Created by Peter Molnar on 29/11/2021.
//

import SwiftUI

class User: ObservableObject {
    @Published var firstName = "Bilbo"
    @Published var lastName = "Baggins"
}

struct ContentView: View {
    @StateObject private var user = User()
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            .sheet(isPresented: $showingSheet) {
                SecondView(name: "Peter")
            }
            Divider()
            Text("Your name is \(user.firstName) \(user.lastName).")
            
            TextField("First Name", text: $user.firstName)
            TextField("Last Name", text: $user.lastName)
        }
    }
}

struct SecondView: View {
    let name: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Hello \(name)")
            Divider()
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
