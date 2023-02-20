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
    
    
    var body: some View {
        NavigationView {
            List(appxs) { appx in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(appx.name).font(.callout)
//                        TextField("category", text: $appx.catg,  onCommit: {
//                            print("kkkkk")
//                        })
                    }
                    Text(appx.appBundleId).font(.caption)
                }
                .onLongPressGesture {
                    
                    self.selectedValue = appx.name
                    self.isShowingPopup = true
                }
            }
            .id(UUID())
            .navigationTitle("Apps")
            .popover(isPresented: $isShowingPopup) {
                if let selectedValue = self.selectedValue {
                    PopupView(selectedValue: selectedValue)
                }
            }
        }
                
        .onAppear {
            Task {
                let recordType = "appProfiles"
                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
                let dbs = CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
                
                do {
                    let records = try await dbs.perform(query, inZoneWith: nil)
                    let newAppxs = records.compactMap { record -> Appx? in
                        guard let nameValue = record["name"] as? String, let bundle = record["appBundleId"] as? String else { return nil }
                        return Appx(appBundleId: bundle, name: nameValue, desc: "desc", catg: "ctg")
//                        return Appx(appBundleId: bundle, name: nameValue, desc: record["description"], catg: record["category"] ?? "")
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
