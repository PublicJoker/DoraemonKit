//
//  HierarchyDetailViewController.swift
//  DoraemonKit-Swift
//
//  Created by Tony-sg on 2020/6/23.
//

class HierarchyDetailViewController: HierarchyTableViewController {
    public var selectView: UIView?
    
    private lazy var segmentedControl: UISegmentedControl = {
        $0.frame = CGRect(x: 10, y: 10, width: view.width - 10 * 2, height: 30)
        $0.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        $0.selectedSegmentIndex = 0
        return $0
    }(UISegmentedControl(items: ["Object", "Size"]))
    
    private lazy var objectDatas = [HierarchyCategoryModel]()
    
    private lazy var sizeDatas = [HierarchyCategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(self.selectView != nil, "SelectView can't be nil")
        
        self.title = LocalizedString("UI结构")
    }
    
    @objc func didReceiveDoraemonHierarchyChangeNotification(_ noti: Notification) {
        loadData()
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        reloadTableView()
    }
    
    func loadData() {
        objectDatas.removeAll()
        
        let models = selectView!.doraemon_hierarchyCategoryModels()
        objectDatas += models
        
        sizeDatas.removeAll()
        let sizeModels = selectView!.doraemon_sizeHierarchyCategoryModels()
        sizeDatas += sizeModels
        reloadTableView()
    }
    
    func reloadTableView() {
        dataArray.removeAll()
        
        if (segmentedControl.selectedSegmentIndex == 0) {
            dataArray += objectDatas
        } else if (segmentedControl.selectedSegmentIndex == 1) {
            dataArray += sizeDatas
        }
        tableView.reloadData()
    }
}
