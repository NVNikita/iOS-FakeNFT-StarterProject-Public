import UIKit

final class EditProfileRouterImpl: EditProfileRouterInput {
    
    weak var viewController: UIViewController?
    
    func dismiss() {
        if let nav = viewController?.navigationController {
            nav.popViewController(animated: true)
        } else {
            viewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func presentAvatarURLPrompt(completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(
            title: NSLocalizedString("EnterImageURL", comment: ""),
            message: NSLocalizedString("PleaseEnterURLForAvatar", comment: ""),
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = NSLocalizedString("AvatarURL", comment: "")
            textField.keyboardType = .URL
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        }
        
        let confirmAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            let text = alertController.textFields?.first?.text
            completion(text)
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            completion(nil)
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
}

