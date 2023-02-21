//
//  ListOfAppsProfiles.swift
//  addAppsToCloudkit
//
//  Created by Steven Hertz on 2/20/23.
//

import SwiftUI
import CloudKit




struct ListOfAppsProfiles: View {
    
    
    var dbs : CKDatabase {
        return CKContainer(identifier: "iCloud.com.developItSolutions.StudentLogins").publicCloudDatabase
    }
    
    @EnvironmentObject var appWork: AppWork
    
    @State private var searchText = ""
    
    var listOfNames = Array<String>()
    
    
    @State private var appos: [Appo] = [
        Appo(cloudkitKey: "ca.ripplepublishing.countsortmatch-188", name: "Count, Sort and Match", category: "Numbers"),
        Appo(cloudkitKey: "busythings.qdapps.feedthemonkey-193", name: "Feed the Monkey", category: "Alphabet"),
        Appo(cloudkitKey: "mobi.abcmouse.academy-190", name: "ABCmouse.com")
    ]
    
    @StateObject var appProfileVM = AppProfileViewModel()
    
    
    
    fileprivate func getAppProfilesFromcloudKit(_ listOfNames: [String]) {
        print("*** begining getAppProfilesFromcloudKit" )
        let recordType = "appProfiles"
        
        let predicate = NSPredicate(format: "profileName != %@", "dummy")
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 500 // Set the limit to 500 records
        
        var newAppProfiles = [AppProfile]()
        operation.recordFetchedBlock = { record in
            
            guard
                let cloudkitKeyValue    = record.recordID.recordName as? String,
                let nameValue           = record["name"] as? String,
                let categoryValue       = record["category"] as? String,
                let profileNameValue    = record["profileName"] as? String,
                let locationIdValue     = record["locationId"] as? Int,
                let iconURLeValue       = record["icon"] as? String,
                let appBundleIdValue    = record["appBundleId"] as? String
                    
            else { fatalError("didnt work") }
            
            if listOfNames.contains(nameValue) {
                    //                            newAppProfiles.append(Appo(cloudkitKey: cloudkitKeyValue, name: nameValue, category: categoryValue, profileName: profileNameValue))
                newAppProfiles.append(AppProfile(appBundleId: appBundleIdValue, locationId: locationIdValue, category: categoryValue, profileName: profileNameValue, name: nameValue, iconURL: iconURLeValue))
            }
            
        }
        
        operation.queryCompletionBlock = { (cursor, error) in
            if let error = error {
                print("Error fetching records: \(error.localizedDescription)")
            } else  {
                print(print("*** success closure of  getAppProfilesFromcloudKit" ))
                DispatchQueue.main.async {
                    self.appProfileVM.appProfiles = newAppProfiles.sorted()
                }
            }
        }
        dbs.add(operation)
    }
    
    
 
    
    
    var body: some View {
        NavigationView {
            List(appProfileVM.appProfiles) { appProfile in
                HStack {
                    AsyncImage(url: URL(string: appProfile.iconURL)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                Text(appProfile.name)
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .frame(height: 20) // Set the height of each row
            }
            }
            .navigationTitle("App Profiles")
            .task {
                Task {
                    do {
                   
                    let listOfNames =   await try getProfilesFromMDM()

                    print("*** before getAppProfilesFromcloudKit" )
                    getAppProfilesFromcloudKit(listOfNames)
                    print("*** after getAppProfilesFromcloudKit" )
//                        DispatchQueue.main.async {
//                            self.appProfileVM.appProfiles = newProfilesSorted
//                        }

                
                    } catch let error as ApiError {
                             //  FIXME: -  put in alert that will display approriate error message
                         print(error.description)
                     }
//                    print("*** end of Task" )
                 }
//                print("*** leaving task modifier" )
            }
        }
    }
    
    func getProfilesFromMDM() async throws -> [String] {
        let profileResponse: ProfileResponse = try await ApiManager.shared.getData(from: .getProfiles)
        var listOfNames = profileResponse.profiles.compactMap {
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

struct ListOfAppsProfiles_Previews: PreviewProvider {
    static var previews: some View {
        ListOfAppsProfiles()
    }
}
