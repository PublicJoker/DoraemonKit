//
//  HierarchyTableViewController.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var tableView: UITableView = {
//        $0.delegate = self()
//        $0.dataSource = self()
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        return $0
    }(UITableView(frame: CGRect.zero, style: .grouped))
    
    lazy var dataArray = [HierarchyCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HierarchyTableViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
