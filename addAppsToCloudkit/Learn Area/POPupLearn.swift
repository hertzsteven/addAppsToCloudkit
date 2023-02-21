//
//  POPupLearn.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/21/23.
//

import SwiftUI
import CloudKit
//struct Item: Identifiable {
//    let id = UUID()
//    let name: String
//    let description: String
//}
//
//struct POPupLearn: View {
//    let items = [
//        Item(name: "Item 1", description: "This is item 1"),
//        Item(name: "Item 2", description: "This is item 2"),
//        Item(name: "Item 3", description: "This is item 3"),
//        Item(name: "Item 4", description: "This is item 4"),
//        Item(name: "Item 5", description: "This is item 5")
//    ]
//
//    @State private var selectedItem: Item? = nil
//
//    var body: some View {
//        List(items) { item in
//            Text(item.name)
//                .onLongPressGesture {
//                    selectedItem = item
//                }
//        }
//        .sheet(item: $selectedItem) { item in
//            Text(item.description)
//        }
//    }
//}


struct Item: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let ckRecId: CKRecord.ID
}

struct ItemDetailView: View {
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }

    let ckRecId: CKRecord.ID
    
    @State private var comments: String?
    
    var body: some View {
        VStack {
            if let comments = comments {
                Text(comments)
                    .padding()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                do {
                    let record = try await fetchRecord(ckRecId)
                    comments = record["description"] as? String
                } catch {
                    print("Error fetching record: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func fetchRecord(_ recordID: CKRecord.ID) async throws -> CKRecord {
//        let dbs = CKContainer.default().publicCloudDatabase
        let record = try await dbs.record(for: recordID)
        return record
    }
}

struct POPupLearn: View {
    let items = [
        Item(name: "Item 1", description: "This is item 1", ckRecId: CKRecord.ID(recordName: "com.MyFirstApp.TeachersPack3")),
        Item(name: "Item 2", description: "This is item 2", ckRecId: CKRecord.ID(recordName: "com.alligatorapps.learningpatternspro")),
        Item(name: "Item 3", description: "This is item 3", ckRecId: CKRecord.ID(recordName: "com.24x7digital.TeachMe")),
        Item(name: "Item 4", description: "This is item 4", ckRecId: CKRecord.ID(recordName: "com.24x7digital.TeachMe")),
        Item(name: "Item 5", description: "This is item 5", ckRecId: CKRecord.ID(recordName: "com.MyFirstApp.TeachersPack3"))
    ]
    
    @State private var selectedItem: Item? = nil
    
    var body: some View {
        List(items) { item in
            Text(item.name)
                .onLongPressGesture {
                    selectedItem = item
                }
        }
        .sheet(item: $selectedItem) { item in
            ItemDetailView(ckRecId: item.ckRecId)
        }
    }
}


struct POPupLearn_Previews: PreviewProvider {
    static var previews: some View {
        POPupLearn()
    }
}
