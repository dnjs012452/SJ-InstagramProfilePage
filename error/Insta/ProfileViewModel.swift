
import CoreData
import UIKit

class ProfileViewModel {
    var userModel: UserModel? {
        didSet {
            onCompleted(userModel)
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    var container: NSPersistentContainer!
    
    var onCompleted: (UserModel?) -> Void = { _ in }
    
    func loadUser() {
        print(#function)
        context?.perform {
            let request: NSFetchRequest<UserModel> =
                UserModel.fetchRequest()
            do {
                let fetchedUserModels = try
                    self.context?.fetch(request)
                if let user = fetchedUserModels?.first {
                    self.userModel = user
                }
            } catch {
                print("Error context \(error)")
            }
        }
    }
    
    func saveUser() {
        if let context = context {
            userModel = UserModel(context: context)
            userModel?.id = "S_____J05"
            userModel?.name = "성준"
            userModel?.introduction = "samdae500 드가자~"
        }
        
        do {
            try context?.save()
            print("User saved successfully.")
        } catch {
            print("Error saving user: \(error)")
        }
    }
}
