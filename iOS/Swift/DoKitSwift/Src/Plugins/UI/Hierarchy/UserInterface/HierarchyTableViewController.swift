//
//  HierarchyTableViewController.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyTableViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var style: UITableView.Style? = .grouped
    
    var tableView: UITableView = {
        $0.bounces = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.estimatedSectionFooterHeight = 0
        $0.estimatedSectionHeaderHeight = 0
        $0.register(HierarchySwitchCell.self, forCellReuseIdentifier: NSStringFromClass(HierarchySwitchCell.self))
        $0.register(HierarchyDetailTitleCell.self, forCellReuseIdentifier: NSStringFromClass(HierarchyDetailTitleCell.self))
        $0.register(HierarchySelectorCell.self, forCellReuseIdentifier: NSStringFromClass(HierarchySelectorCell.self))
    
        if #available(iOS 11.0, *) {
            $0.contentInsetAdjustmentBehavior = .automatic
        }
        return $0
    }(UITableView(frame: CGRect.zero, style: .grouped))
    
    lazy var dataArray = [HierarchyCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = CGRect(x: 0, y: bigTitleView?.bottom ?? 0, width: view.width, height: view.height - (bigTitleView?.bottom ?? 0))
    }
}

extension HierarchyTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataArray[section]
        
        guard model.title?.isEmpty != false else {
            return nil
        }
        
        let headerView = HierarchyHeaderView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        headerView.titleLabel.text = model.title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = dataArray[section]
        
        guard model.title?.isEmpty != false else {
            return CGFloat.leastNormalMagnitude
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.section].items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: (model?.cellClass)!) ?? UITableViewCell()
        cell.setValue(model, forKey: "model")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataArray[indexPath.section].items?[indexPath.row]
        model?.block?()
    }
}
