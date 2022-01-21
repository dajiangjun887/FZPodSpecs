//
//  FZDropView.swift
//
//  Created by Jack on 2021/11/12.
//

import UIKit
import SnapKit
import FZCommitKit

protocol FZDropDownProtocol: AnyObject {
    func didClickDropDownTitle(title: String)
}

class FZDropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
    
    var dropDownTitleArr = [String]()
    weak var delegate: FZDropDownProtocol?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
       return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
        
    private func setupUI() {
        backgroundColor = .white

        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.fit)
            make.width.centerX.bottom.equalToSuperview()
        }
    }
                
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropDownTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.fit
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dropDownTitleArr[indexPath.row]
        cell.textLabel?.font = 10.regularPFFont
        cell.textLabel?.textColor = UIColor.gray
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didClickDropDownTitle(title: dropDownTitleArr[indexPath.row])
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIView {
    
    func setBorderWithView(top: Bool, left: Bool, bottom: Bool, right: Bool, lineWidth: CGFloat, color: UIColor) {
        if top {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: lineWidth)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if left {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: lineWidth, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if bottom {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: self.frame.size.height - lineWidth, width: self.frame.size.width, height: lineWidth)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }

        if right {
            let layer = CALayer()
            layer.frame = CGRect(x: self.frame.size.width - lineWidth, y: 0, width: lineWidth, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
    }
    
}


 
