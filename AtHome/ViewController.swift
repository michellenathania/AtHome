import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            // When there is no text, filteredData is the same as the original data
            // When user has entered text into the search box
            // Use the filter method to iterate over all items in the data array
            // For each item, return true if the item should be included and false if the
            // item should NOT be included
            filteredData = searchText.isEmpty ? data : data.filter { (item: ItemQuantity) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.item?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            
            tableView.reloadData()
        }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
   var data = [ItemQuantity]()
    var filteredData = [ItemQuantity]()
    let searchController = UISearchController()

    override func viewDidLoad() {
        tableView.layer.cornerRadius = 30
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "What's At Home?"
        searchBar.delegate = self
        searchBar.layer.borderWidth = 0
        let bgColor: UIColor = UIColor(red:13, green:171, blue: 118, alpha: 100)
        searchBar.layer.borderColor = bgColor.cgColor
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search Items", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])

        searchBar.setMagnifyingGlassColorTo(color: UIColor.white)
        searchBar.setClearButtonColorTo(color: UIColor.white)
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = UIColor.white
       
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = ItemQuantity.fetchRequest()
        do {
            data = try context.fetch(fetchRequest)
        } catch {
           print (error)
        }
        filteredData = data
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addRowToEnd))
            navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func addRowToEnd() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let ItemQuantity = ItemQuantity(context: context)
        ItemQuantity.quantity = 1
        ItemQuantity.item = "Item"
        do {
            context.insert(ItemQuantity)
            try context.save()
        } catch {
           print (error)
        }
        data.append(ItemQuantity)
        filteredData = data
        searchBar.text = ""
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredData.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredData.count

        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell)!
            cell.selectionStyle = .none
            cell.ItemQuantity = filteredData [ indexPath.row ]
            cell.itemName.text = cell.ItemQuantity?.item
            let amount=Double (cell.ItemQuantity!.quantity )
            cell.itemAmount.text = String (Int(amount))
            cell.stepper.value = amount
            return cell
        }
    
    func tableView(_ tableView: UITableView,
                        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
         {
             let deleteItem = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                 
                 DispatchQueue.main.async {
                     self.showDeleteWarning(for: indexPath)
                 }
                 
                 success(true)
             })
             deleteItem.backgroundColor = .red
             return UISwipeActionsConfiguration(actions: [deleteItem])
         }
      
      func showDeleteWarning(for indexPath: IndexPath) {
          let deleteAlert = UIAlertController(title: "Delete Item?", message: "This item will be permanently deleted from this list.", preferredStyle: UIAlertController.Style.alert)

          let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
              DispatchQueue.main.async {
                  let ItemQuantity = self.filteredData.remove(at: indexPath.row)
                  for index in 0..<self.data.count
                  {
                      if ItemQuantity == self.data [index] {
                          self.data.remove(at: index)
                          break
                      }
                  }
                  let appdelegate = UIApplication.shared.delegate as! AppDelegate
                  let context = appdelegate.persistentContainer.viewContext
                  do {
                      context.delete(ItemQuantity)
                      try context.save()
                  } catch {
                     print (error)
                  }
                  self.tableView.deleteRows(at: [indexPath], with: .fade)
              }
          }
          
          let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                      self.dismiss(animated: true, completion: nil)
                  })
          
          deleteAlert.addAction(cancelAction)
          deleteAlert.addAction(deleteAction)
          present(deleteAlert, animated: true, completion: nil)
      }
}

extension UISearchBar
{

    func setMagnifyingGlassColorTo(color: UIColor)
    {
        // Search Icon
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = color
    }

    func setClearButtonColorTo(color: UIColor)
    {
        // Clear Button
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        let crossIconView = textFieldInsideSearchBar?.value(forKey: "clearButton") as? UIButton
        crossIconView?.setImage(crossIconView?.currentImage?.withRenderingMode(.alwaysTemplate), for: .normal)
        crossIconView?.tintColor = color
    }

}

