//
//  LearnMakecloudkitasync.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/21/23.
//

import SwiftUI
import CloudKit

struct LearnMakecloudkitasync: View {
    
    var listOfNames = Array<String>()
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }

    @State private var appos: [AppProfile] = []
    var body: some View {
        VStack {
            Button("do old way cloudkit") {
                Task {
                    do {
                        
                        let listOfNames =   try await getProfilesFromMDM()

                        try await fetchRecords(listOfNames: listOfNames)
                        
                        
                        for appr in appos {
                            print(appr.name)
                                  
                                  
                     }
      
//                        let records = try await fetchRecords()
                        // Handle the fetched records...
                    } catch {
                        // Handle any errors that occurred...
                        print("there was an error")
                    }
                }
            }
        }
       
    }
    
    
    
    func fetchRecords(listOfNames: [String]) async throws -> Void {
        let recordType = "appProfiles"
            //        let predicate = NSPredicate(format: "category = %@", "Nnnnn")
        let query = CKQuery(recordType: recordType, predicate: NSPredicate(format: "TRUEPREDICATE"))
        
            //        do {
        let listofAppProfiles = try await dbs.records(matching: query, inZoneWith: nil, desiredKeys: nil, resultsLimit: 0)
        
            // run on main thread
        await MainActor.run {
                // make an array to hold the appProfiles
            var newAppProfiles = [AppProfile]()
            
                // Loop through the returned recors
            for (_, result ) in listofAppProfiles.matchResults {
                guard let record = try? result.get(),
                      let cloudkitKeyValue    = record.recordID.recordName as? String,
                      let nameValue           = record["name"] as? String,
                      let categoryValue       = record["category"] as? String,
                      let profileNameValue    = record["profileName"] as? String,
                      let locationIdValue     = record["locationId"] as? Int,
                      let iconURLeValue       = record["icon"] as? String,
                      let appBundleIdValue    = record["appBundleId"] as? String
                        
                else { fatalError("didn work") }
                
                if listOfNames.contains(nameValue) {
                        //                            newAppProfiles.append(Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue))
                    newAppProfiles.append(AppProfile(appBundleId: appBundleIdValue, locationId: locationIdValue, category: categoryValue, profileName: profileNameValue, name: nameValue, iconURL: iconURLeValue))
                }
                
            }
            appos = newAppProfiles
            
                //        } catch  {
                //            print("Error: \(error)")
                //        }
        }
    }
    
    
    func getProfilesFromMDM() async throws -> [String] {
        let profileResponse: ProfileResponse = try await ApiManager.shared.getData(from: .getProfiles)
        let listOfNames = profileResponse.profiles.compactMap {
//                            let identifier  = $0.identifier
            if $0.name.contains("Profile-App-1Kiosk") {
                let nm =  $0.name.replacingOccurrences(of: "Profile-App-1Kiosk ", with: "")
                    //                            let ctg = "kdkd"
                    //                            let appo = Appo(cloudkitKey: identifier, name: nm, category: ctg, profileName: "dummy")
                return nm } else {
                    return nil
                }
        }
        return listOfNames
    }
    
}

//    func fetchRecords() async throws -> [Appo] {
//        let recordType = "appProfiles"
//        let predicate = NSPredicate(format: "category = %@", "Nnnnn")
//        let query = CKQuery(recordType: recordType, predicate: predicate)
//        query.limit = 500 // Set the limit to 500 records
//
//        let operation = CKQueryOperation(query: query)
//        var newAppos = [Appo]()
//
//        operation.recordFetchedBlock = { record in
//            guard   let nameValue           = record["name"] as? String,
//                    let cloudkitKeyValue    = record.recordID.recordName as? String,
//                    let categoryValue       = record["category"] as? String,
//                    let profileNameValue    = record["profileName"] as? String
//            else {
//                fatalError("Couldn't parse record data.")
//            }
//
//            newAppos.append(Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue))
//        }
//
//        let fetchedRecords = try await dbs.sync { (dbs, continuation) in
//            var fetchedRecords = [CKRecord]()
//
//            operation.queryCompletionBlock = { (cursor, error) in
//                if let error = error {
//                    // If an error occurred, throw it using the CheckedContinuation
//                    continuation.resume(throwing: error)
//                } else {
//                    // If the operation succeeded, return the fetched records using the CheckedContinuation
//                    continuation.resume(returning: fetchedRecords)
//                }
//            }
//
//            operation.recordFetchedBlock = { record in
//                fetchedRecords.append(record)
//            }
//
//            try dbs.execute(operation)
//        }
//
//        return newAppos
//    }
//
//



struct LearnMakecloudkitasync_Previews: PreviewProvider {
    static var previews: some View {
        LearnMakecloudkitasync()
    }
}
