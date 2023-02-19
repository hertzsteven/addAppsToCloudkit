//
//  ListStub.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/17/23.
//

import SwiftUI
import CloudKit

struct Appx: Identifiable {
    let id = UUID().uuidString
    let appBundleId: String
    let name: String
    let desc: String?
    var catg: String
}

struct ListStub: View {
    @State private var isShowingPopup = false
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }


    @State var appxs = [Appx]()
    @State private var selectedValue: String? = nil
    
    let names = ["Sam", "harry", "jack"]
    
    var body: some View {
        NavigationView {
            List($appxs) { $appx in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(appx.name).font(.callout)
                        TextField("category", text: $appx.catg,  onCommit: {
                                print("kkkkk")
                            })
                    }
                    Text(appx.appBundleId).font(.caption)
                }
//                .onDisappear {
//                    print("it is disappering \(appx.name)")
//                }
//                .onTapGesture {
//                    self.isShowingPopup = true
//                }
                .onLongPressGesture {
                    
                    self.selectedValue = appx.name
                                      self.isShowingPopup = true
                                  }
            }
            .navigationTitle("Apps")
            .popover(isPresented: $isShowingPopup) {
                if let selectedValue = self.selectedValue {
                     PopupView(selectedValue: selectedValue)
                 }
      
//                PopupView(selectedValue:  self.selectedValue ?? "hello")
            }
        }
//        .task {
//            Task {
//                let recordType = "apptest"
//                 let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//
//                DispatchQueue.global(qos: .background).async {
//                        // Perform some work in the background
//                    
//                    dbs.perform(query, inZoneWith: nil) { (records, error) in
//                        if let error = error {
//                            print("Error fetching records: \(error.localizedDescription)")
//                        } else if let records = records {
//                            for record in records {
//                                DispatchQueue.main.async {
//                                    if let nameValue = record["name"] as? String,
//                                       let bundle =  record["appBundleId"] as? String {
//                                        appxs.append(Appx(appBundleId: bundle, name: nameValue, desc: record["description"], catg: record["category"] ?? ""))
//                                        print("Record ID: \(record.recordID.recordName), Field Value: \(nameValue)")
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    
//                }
//            }
//        }
        
.onAppear {
Task {
    let recordType = "apptest"
    let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
    let dbs = CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase

    do {
        let records = try await dbs.perform(query, inZoneWith: nil)
        let newAppxs = records.compactMap { record -> Appx? in
            guard let nameValue = record["name"] as? String, let bundle = record["appBundleId"] as? String else { return nil }
            return Appx(appBundleId: bundle, name: nameValue, desc: record["description"], catg: record["category"] ?? "")
        }

        DispatchQueue.main.async {
            self.appxs = newAppxs
        }

    } catch {
        print("Error fetching records: \(error.localizedDescription)")
    }
}
}

    }
        
}

struct PopupView: View {
    @State private var shouldShowPopup = false
    let selectedValue: String
    var body: some View {
        Text(selectedValue)
            .padding()
            .onAppear {
                self.shouldShowPopup = true
            }
            .background(shouldShowPopup ? Color.clear : Color.black.opacity(0.001))
    }
}

struct ListStub_Previews: PreviewProvider {
    static var previews: some View {
        ListStub()
    }
}
