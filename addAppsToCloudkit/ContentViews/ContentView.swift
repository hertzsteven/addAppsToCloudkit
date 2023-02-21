
//  ContentView.swift
//  MaintainApppInfoINFireBase
//
//  Created by Steven Hertz on 2/16/23.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    var dbs : CKDatabase {
//        return CKContainer(identifier: "iCloud.com.developItSolutions.teststudentlogin").publicCloudDatabase
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
      }

    fileprivate func updateAddRecUsing(theID recordID: CKRecord.ID, withName name: String) {
        dbs.fetch(withRecordID: recordID) { (record, error) in
            if let error = error {
                print("Error fetching record: \(error)")
            } else if let record = record {
                record["name"] = name
                dbs.save(record) { (record, error) in
                    print("```* - * - Saving . . .")
                    if let error = error {
                        print("```* - * - error saving it \(error)")
                    } else {
                        print("```* - * - succesful ***")
                    }
                }
                print("Fetched record: \(record)")
            } else {
                print("Record not found")
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
            Button("add or update") {
                    // Create a CKRecord.ID object from the record name and zone ID
                    let recordID = CKRecord.ID(recordName: "com.thup.fixit-196")

                updateAddRecUsing(theID: recordID, withName: "from function")

                
                
                    /// Instantiate a CKRecord with the CKRecordID
//                 let record = CKRecord(recordType: "testProfilesForApps", recordID: CKRecord.ID(recordName: "com.pinger.chalktalk"))
//                     /// populate the 2 fields
//                 record["appBundleId"] = "xxxiCloud.com.developItSolutions.StudentLogins"
//                 record["name"] = "third one"
//                     /// save it
//                 dbs.save(record) { (record, error) in
//                     print("```* - * - Saving . . .")
//                          if let error = error {
//                             print("```* - * - error saving it \(error)")
//                         } else {
//                             print("```* - * - succesful ***")
//                             print(record as Any)
//                         }
//
//                 }

            }
            
            Button("cloudkit add data") {
                
                    /// Instantiate a CKRecord with the CKRecordID
                let record = CKRecord(recordType: "testProfilesForApps", recordID: CKRecord.ID(recordName: "iCloud.com.dia.cloudKitExample.open"))
                    /// populate the 2 fields
                record["appBundleId"] = "iCloud.com.developItSolutions.StudentLogins"
                record["name"] = "second one"
                    /// save it
                dbs.save(record) { (record, error) in
                    print("```* - * - Saving . . .")
                    DispatchQueue.main.async {
                        if let error = error {
                            print("```* - * - error saving it \(error)")
                        } else {
                            print("```* - * - succesful ***")
                            print(record as Any)
                        }
                    }
                }
                    /// Instantiate a CKRecord with the CKRecordID
                  let record2 = CKRecord(recordType: "testProfilesForApps", recordID: CKRecord.ID(recordName: "com.24x7digital.TeachMe"))
                      /// populate the 2 fields
                  record2["appBundleId"] = "com.24x7digital.TeachMe"
                  record2["name"] = "second one"
                      /// save it
                  dbs.save(record2) { (record, error) in
                      print("```* - * - Saving . . .")
                      DispatchQueue.main.async {
                          if let error = error {
                              print("```* - * - error saving it \(error)")
                          } else {
                              print("```* - * - succesful ***")
                              print(record as Any)
                          }
                      }
                  }
                  
                    /// Instantiate a CKRecord with the CKRecordID
                  let record3 = CKRecord(recordType: "testProfilesForApps", recordID: CKRecord.ID(recordName: "com.pinger.chalktalk"))
                      /// populate the 2 fields
                  record3["appBundleId"] = "com.pinger.chalktalk"
                  record3["name"] = "second one"
                      /// save it
                  dbs.save(record3) { (record, error) in
                      print("```* - * - Saving . . .")
                      DispatchQueue.main.async {
                          if let error = error {
                              print("```* - * - error saving it \(error)")
                          } else {
                              print("```* - * - succesful ***")
                              print(record as Any)
                          }
                      }
                  }
            }
            
            Button("cloudkit delete all") {
                
                let query = CKQuery(recordType: "appProfiles", predicate: NSPredicate(value: true))
                
                dbs.perform(query, inZoneWith: nil) { (records, error) in
                    if let error = error {
                        print("Error fetching records: \(error.localizedDescription)")
                    } else if let records = records {
                        let deleteOperation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records.map { $0.recordID })
                        deleteOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                            if let error = error {
                                print("Error deleting records: \(error.localizedDescription)")
                            } else {
                                print("Deleted \(deletedRecordIDs?.count) records")
                            }
                        }
                        dbs.add(deleteOperation)
                    }
                }
            }
            
            Button("cloudkit print all") {
                
                let recordType = "appProfiles"
                
                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
                let operation = CKQueryOperation(query: query)
                operation.resultsLimit = 500 // Set the limit to 500 records
//                var allRecords = [CKRecord]() // Array to hold all the fetched records
                
                operation.recordFetchedBlock = { record in
                    if let fieldValue = record["name"] as? String {
                        print(" \(fieldValue) -  \(record.recordID.recordName) ")
                    }
                }
                
                operation.queryCompletionBlock = { (cursor, error) in
                    if let error = error {
                        print("Error fetching records: \(error.localizedDescription)")
                    } else  {
                        print("****** things worked")
                    }
                }
                dbs.add(operation)
            }
            
            Button("remove field by copying") {
                let recordType = "MyRecordType"
                let fieldToRemove = "fieldToRemove"

                let query = CKQuery(recordType: recordType, predicate: NSPredicate(value: true))
                let operation = CKQueryOperation(query: query)

                operation.recordFetchedBlock = { record in
                    // Create a new record without the field to remove
                    let newRecord = CKRecord(recordType: recordType, recordID: record.recordID)
                    for (key, value) in record {
                        if key != fieldToRemove {
                            newRecord[key] = value
                        }
                    }

                    // Update the record in the database
                    let modifyOperation = CKModifyRecordsOperation(recordsToSave: [newRecord], recordIDsToDelete: [record.recordID])
                    modifyOperation.savePolicy = .changedKeys
                    modifyOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                        // Handle any errors or do additional processing here
                    }
                    CKContainer.default().privateCloudDatabase.add(modifyOperation)
                }

                CKContainer.default().privateCloudDatabase.add(operation)
            }
            
            Button("get profiles") {
                print("getting the apps")
                Task {
                    do {
                        let profileResponse: ProfileResponse = try await ApiManager.shared.getData(from: .getProfiles)
                            dump(profileResponse)
                        let names = profileResponse.profiles.map {
                            $0.name.replacingOccurrences(of: "Profile-App-1Kiosk ", with: "").replacingOccurrences(of: "Profile-App-Kiosk ", with: "")
                        }
                    } catch let error as ApiError {
                             //  FIXME: -  put in alert that will display approriate error message
                         print(error.description)
                     }
                 }
            }
            
            Button {
                print("getting the apps")
                Task {
                    do {
                        let appResponse: AppResponse = try await ApiManager.shared.getData(from: .getApps)
                            //                        dump(appResponse)
                        
                        for app in appResponse.apps {
                                //                            let record = CKRecord(recordType: "appProfiles", recordID: CKRecord.ID(recordName: "\(app.bundleId)"))
                            do {
                                print(app.name, app.bundleId)
                                
                                if app.name.contains("TeachMe") {
                                    print(app.name, "it is doodle")
//                                let recordID = CKRecord.ID(recordName: "\(app.bundleId)-\(app.id)")
                                    let record = CKRecord(recordType: "appProfiles", recordID: CKRecord.ID(recordName: "\(app.bundleId)"))
                                    record["appBundleId"] = app.bundleId
                                    record["name"] = app.name
                                    record["id"] = app.id
                                    record["locationId"] = app.locationId
                                    record["description"] = app.description
                                    record["icon"] = app.icon
                                    record["category"] = "dummy"
                                    record["profileName"] = "duummy"
                                    /// save it
                                    dbs.save(record) { (record, error) in
                                    print("```* - * - Saving . . .")
                                        //   DispatchQueue.main.async {
                                    if let error = error {
                                        print("```* - * - error saving it \(error)")
                                    } else {
                                        print("```* - * - succesful ***")
                                        print(record as Any)
                                    }
                                         }
                                } else {
//                                    print("not doing ", app.name)
//                                    print("\(app.bundleId)-\(app.id)")
                                }
//                            }
                        }
 
                                
                            catch {
                                print("Error fetching records: \(error.localizedDescription)")
                            }
                        }
                        
                    } catch let error as ApiError {
                            //  FIXME: -  put in alert that will display approriate error message
                        print(error.description)
                    }
                    
                    print("in task after do")
                    
                }
                print("after task")
                
            } label: {
                Text("get the apps")
            }
            
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
