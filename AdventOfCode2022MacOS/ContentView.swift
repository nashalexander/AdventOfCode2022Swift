//
//  ContentView.swift
//  AdventOfCode2022MacOS
//
//  Created by Alex on 12/28/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var doImportFile = false
    @State var selectedFilename : URL? = nil
    @State var selectedMethod = AdventMethod.None
    @State var outputString = ""

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        HStack{
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
            VStack{
                HStack{
                    Text(selectedFilename?.lastPathComponent ?? "none")
                    
                    Button("Select File") {
                        doImportFile = true
                    }.fileImporter(isPresented: $doImportFile, allowedContentTypes: [.data]) { result in
                        switch result
                        {
                        case .success(let file):
                            selectedFilename = file
                        case .failure(let error):
                            print(error)
                        }
                        doImportFile = false
                    }
                }
                
                Picker(selection: $selectedMethod, label: Text("Method")) {
                    Text("RuckSack").tag(AdventMethod.RuckSack)
                        .tag(AdventMethod.CampCleaning)
                    Text("RockPaperScissors").tag(AdventMethod.RockPaperScissors)
                    Text("CalorieTracker").tag(AdventMethod.CalorieTracker)
                    Text("CargoStacks").tag(AdventMethod.CargoStacks)
                    Text("SignalTransmitter").tag(AdventMethod.SignalTransmitter)
                    Text("FileSystemParser").tag(AdventMethod.FileSystemParser)
                }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                Button("Execute")
                {
                    if let fileUrl = selectedFilename {
                        outputString = executeAdvent(method: selectedMethod, files: [fileUrl.relativePath])
                    }
                    else
                    {
                        print("selectedFilename is nil")
                    }
                }
            }
            List{
                Text(outputString)
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
