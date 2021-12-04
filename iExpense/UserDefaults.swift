//
//  UserDefaults.swift
//  iExpense
//
//  Created by Peter Molnar on 04/12/2021.
//

import SwiftUI

struct UserCodable: Codable {
    let firstName: String
    let lastName: String
}

struct UserDefaults: View {
    @State private var user = UserCodable(firstName: "Taylor", lastName: "Swift")
    
    @AppStorage("tapCount") private var tapCount = 0
    
    var body: some View {
        VStack {
            
            Button("Tap count: \(tapCount)") {
                tapCount += 1
            }
            Divider()
            Button("Save User") {
                let encoder = JSONEncoder()
                
                if let data = try? encoder.encode(user) {
                    Foundation.UserDefaults.standard.set(data, forKey: "UserData")
                }
            }
        }
        
    }
}

struct UserDefaults_Previews: PreviewProvider {
    static var previews: some View {
        UserDefaults()
    }
}
