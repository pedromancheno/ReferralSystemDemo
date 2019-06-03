import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var copyLinkButton: UIButton!

    let linkBuilder = FirebaseDynamicLinkBuilder(bundle: Bundle.main)
    var shortURLString: String?

    struct Params: ReferralLinkParameters {
        var referrerID: Int
        var firstName: String?
        var lastName: String?

        init() {
            self.referrerID = 123
            self.firstName = "Pedro"
            self.lastName = "Mancheno"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        copyLinkButton.isEnabled = false
    }

    @IBAction func generateInviteLink(_ sender: Any) {
        linkBuilder.makeLink(for: .invite(params: Params())) { (shortURL, _, _) in
            self.shortURLString = shortURL?.absoluteString
            self.textField.text = self.shortURLString
            self.copyLinkButton.isEnabled = true
        }
    }

    @IBAction func copyLink(_ sender: Any) {
        UIPasteboard.general.string = shortURLString
    }

}

