

import SwiftUI
import CloudKit


struct Appo: Identifiable, Comparable {
    let id = UUID()
    let cloudkitKey: String
    var name: String
    var category: String?
    var profileName: String?
    
    static func < (lhs: Appo, rhs: Appo) -> Bool {
        return lhs.name < rhs.name
    }
    
}

struct PersonListView: View {
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }
    
    // Declare a @State variable to hold the user's search text
    @State private var searchText = ""

    
    @State private var appos: [Appo] = [
        Appo(cloudkitKey: "ca.ripplepublishing.countsortmatch-188", name: "Count, Sort and Match", category: "Numbers"),
        Appo(cloudkitKey: "busythings.qdapps.feedthemonkey-193", name: "Feed the Monkey", category: "Alphabet"),
        Appo(cloudkitKey: "mobi.abcmouse.academy-190", name: "ABCmouse.com")
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                    // Add a text field for the user to enter search text
                TextField("Search", text: $searchText)
                    .padding()
                    .textFieldStyle(.roundedBorder)
                    
                
                
                List(appos.filter { searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased()) }) { appo in
                    
                        //            List(appos) { appo in
                    NavigationLink(
                        destination: DescriptionView(appo: appo,
                                                     didUpdateDescription: { category in
                                                         Task {
                                                             await self.didUpdateDescription(for: appo, with: category)
                                                         }
                                                     },
                                                     didUpdateprofileName: { profileName in
                                                         Task {
                                                             await self.didUpdateprofileName(for: appo, with: profileName)
                                                         }
                                                     }
                                                    ),
                        label: {
                            HStack {
                                Text(appo.name)
                                Spacer()
                                if let category = appo.category {
                                    Text(category)
                                        .foregroundColor(.gray)
                                }
                                if let profileName = appo.profileName {
                                    Text(profileName)
                                        .foregroundColor(.gray)
                                }
                            }.font(.system(size: 14))
                                .frame(height: 20) // Set the height of each row
                                
                  
                        }
                    ).listRowBackground(Color.white)
                }

                .navigationTitle("Apps")
            }
        }
        .onAppear {
            Task {
                let recordType = "apptest"
                
                // Create a predicate that filters records where the "category" property is equal to "Math"
                let predicate = NSPredicate(format: "category = %@", "Nnnnn")

                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
//                let query = CKQuery(recordType: recordType, predicate: predicate)

                let dbs = CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
                
                do {
                    let records = try await dbs.perform(query, inZoneWith: nil)
                    let newAppos = records.compactMap { record -> Appo? in
                        guard   let nameValue           = record["name"] as? String,
                                let cloudkitKeyValue    = record.recordID.recordName as? String,
                                let categoryValue       = record["category"] as? String,
                                let profileNameValue    = record["profileName"] as? String
                        else { return nil }
                        return Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue)
//                        return Appx(appBundleId: bundle, name: nameValue, desc: record["description"], catg: record["category"] ?? "")
                    }
                    
                    DispatchQueue.main.async {
                        self.appos = newAppos.sorted()
                    }
                    
                } catch {
                    print("Error fetching records: \(error.localizedDescription)")
                }
            }
        }
    }
    
    fileprivate func updateAddRecUsing(theID recordID: CKRecord.ID, withCategory category: String) async {
        do {
            let records = try await dbs.records(for: [recordID])
            let firstResult = records.first?.value
            guard let firstRecord = try firstResult?.get() else { fatalError("couldnt do it") }
            firstRecord["category"] = category
            let savedRecord = try await dbs.save(firstRecord)
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    
    fileprivate func updateAddRecUsing(theID recordID: CKRecord.ID, withprofileName profileName: String) async {
        do {
            let records = try await dbs.records(for: [recordID])
            let firstResult = records.first?.value
            guard let firstRecord = try firstResult?.get() else { fatalError("couldnt do it") }
            firstRecord["profileName"] = profileName
            let savedRecord = try await dbs.save(firstRecord)
        } catch {
            print("Error fetching records: \(error.localizedDescription)")
        }
    }
    

    
    func didUpdateDescription(for appo: Appo, with category: String) async {
        if let index = appos.firstIndex(where: { $0.id == appo.id }) {
            if appos[index].category != category {
                appos[index].category = category
                let theId = CKRecord.ID(recordName: appo.cloudkitKey)
                await updateAddRecUsing(theID: theId, withCategory: category)
                DispatchQueue.main.async {
                    showAlert(for: appo)
                }
                
            }
        }
    }
    
    func didUpdateprofileName(for appo: Appo, with profileName: String) async {
        if let index = appos.firstIndex(where: { $0.id == appo.id }) {
            if appos[index].profileName != profileName {
                appos[index].profileName = profileName
                let theId = CKRecord.ID(recordName: appo.cloudkitKey)
                await updateAddRecUsing(theID: theId, withprofileName: profileName)
                DispatchQueue.main.async {
                    showAlert(for: appo)
                }
                
            }
        }
    }

    
    
    func showAlert(for appo: Appo) {
        let alert = UIAlertController(title: "category or profilename Updated", message: "\(appo.name)'s category or profile has been updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}

struct DescriptionView: View {
    @State private var category: String
    @State private var profileName: String
    private let originalDescription: String
    private let originalprofileName: String
    var appo: Appo
    var didUpdateDescription: (String) -> Void
    var didUpdateprofileName: (String) -> Void

    
    init(appo: Appo, didUpdateDescription: @escaping (String) -> Void, didUpdateprofileName: @escaping (String) -> Void) {
        self.appo = appo
        self._category = State(initialValue: appo.category ?? "")
        self._profileName = State(initialValue: appo.profileName ?? "")
        self.originalDescription = appo.category ?? ""
        self.originalprofileName = appo.profileName ?? ""
        self.didUpdateDescription = didUpdateDescription
        self.didUpdateprofileName = didUpdateprofileName

    }
    
    var body: some View {
        VStack {
            Text(appo.name)
                .font(.title)
                .padding(.bottom)
            TextEditor(text: $category)
                .padding()
            TextEditor(text: $profileName)
                .padding()
        }
        .onDisappear {
            if self.category != self.originalDescription {
                // Save the category if it has changed
                didUpdateDescription(category)
            }
            if self.profileName != self.originalprofileName {
                didUpdateprofileName(profileName)
            }
        }
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView()
    }
}
