//
//  ContentView.swift
//  iExpense
//
//  Created by Peter Molnar on 29/11/2021.
//

import SwiftUI
import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

class Expenses: ObservableObject {
    
    init() {
        if let savedItems = Foundation.UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                Foundation.UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ExpenseItemView: View {
    
    let item: ExpenseItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                .fontWeight(item.amount < 10 ? .light : item.amount < 100 ? .medium :  .heavy)
        }
        .accessibilityElement(children: .combine)
        .accessibility(hint: Text("Expense type:" + item.type))
        .accessibility(label: Text("Expense \(item.name) valued as \(String(format: "%.2f", item.amount)) \(Locale.current.currencyCode ?? "USD")"))
    }
}

struct ContentView: View {
    // It is state object, because the view owns it.
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Personal")){
                    ForEach(expenses.items.filter({$0.type == "Personal"})) { item in
                        ExpenseItemView(item: item)
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section(header: Text("Business")){
                    ForEach(expenses.items.filter({$0.type == "Business"})) { item in
                        ExpenseItemView(item: item)
                    }
                    .onDelete(perform: removeBusinessItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        // FIXME: This is not working for sure :/
        offsets.forEach { index in
            print("Index: \(index)")
        }
        expenses.items.remove(atOffsets: offsets)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
