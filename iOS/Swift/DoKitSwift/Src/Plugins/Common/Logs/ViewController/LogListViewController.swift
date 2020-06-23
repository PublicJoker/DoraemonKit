//
//  LogListViewController.swift
//  DoraemonKit-Swift
//
//  Created by I am Groot on 2020/6/19.
//

import UIKit

class LogListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,LogSearchViewDelegate {
    var dataArray:[LogModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.loadData()
    }
    private func initUI() {
        title = LocalizedString("print日志记录")
        //导航item
        let exportItem = UIBarButtonItem.init(title: LocalizedString("导出"), style: .plain, target: self, action: #selector(exportLog))
        let clearItem = UIBarButtonItem.init(title: LocalizedString("清除"), style: .plain, target: self, action: #selector(clearLog))
        navigationItem.setRightBarButtonItems([exportItem,clearItem], animated: false)
        
        
        //搜索框
        let searchView:LogSearchView = LogSearchView.init(frame: CGRect.init(x: 16, y: kIphoneNavBarHeight + kIphoneStatusBarHeight, width: kScreenWidth - 32, height: 50))
        searchView.delegate = self
        view.addSubview(searchView)
        
        //列表
        view.addSubview(logListTableView)
        
        view.addConstraint(NSLayoutConstraint.init(item: logListTableView, attribute: .top, relatedBy: .equal, toItem: searchView, attribute: .bottom, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: logListTableView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: logListTableView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint.init(item: logListTableView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0))
    }
    func loadData() {
        dataArray = LogManager.shared.logs.reversed()
    }
    
    @objc func exportLog() {
        let logArray = LogManager.shared.logs
        var string = String()
        for log in logArray {
            guard let content = log.content  else {
                return
            }
            string += log.dateFormat
            string += " "
            string += content
            string += "\n"
        }
        DoKitUtil.share(obj: string, from: self)
    }
    
    @objc func clearLog() {
        LogManager.shared.clearLog()
        loadData()
        logListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let log = (dataArray?[indexPath.row])!
        let cell:LogListCell = tableView.dequeueReusableCell(withIdentifier: LogListCell.identifier, for: indexPath) as! LogListCell
        cell.renderWithModel(model: log)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let log = (self.dataArray?[indexPath.row])!
        if log.expand {
            return log.cellHeight!
        }else {
            return 50;
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let log = (self.dataArray?[indexPath.row])!
        log.expand = !log.expand
        tableView.reloadData()
    }
    
    func searchKeyword(keyword: String) {
        if keyword.count > 0 {
            loadData()
            var matchArray = [LogModel]()
            for log:LogModel in dataArray! {
                if (log.content?.contains(keyword))! {
                    matchArray.append(log)
                }
            }
            dataArray = matchArray
        }else {
            loadData()
        }
        logListTableView.reloadData()
    }
    lazy var logListTableView: UITableView = {
        $0.register(LogListCell.self, forCellReuseIdentifier: LogListCell.identifier)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.sectionHeaderHeight = 0.1
        $0.separatorStyle = .none
        $0.backgroundColor = .white
        return $0
    }(UITableView(frame: .zero, style: .grouped))
}
