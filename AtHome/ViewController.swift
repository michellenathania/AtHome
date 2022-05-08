import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    let searchBar = UISearchController()
    
    override func viewDidLoad() {
        tableView.layer.cornerRadius = 30
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "What's At Home?"

        navigationItem.searchController = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(addnew))
            navigationController?.navigationBar.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return 1

        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath))

            return cell
            
        }
    
    @objc func addnew() {
    
        }
    
}
