import UIKit

class ItemTableViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet weak var itemName: UITextView!
    @IBOutlet weak var itemAmount: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var ItemQuantity:ItemQuantity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.delegate = self
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do {
            ItemQuantity?.item = textView.text
            try context.save()
        } catch {
           print (error)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       itemName.endEditing(true)
    }
        
    @IBAction func itemQuantityStepper(sender: UIStepper)
    {
        itemName.endEditing(true)
        let amount = Int(sender.value)
        self.itemAmount.text = String(amount)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        do {
            ItemQuantity?.quantity = Int16(amount)
            try context.save()
        } catch {
           print (error)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
