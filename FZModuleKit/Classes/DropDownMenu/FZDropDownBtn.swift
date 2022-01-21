//
//  FZDropDownBtn.swift
//
//  Created by Jack on 2021/11/12.
//

import UIKit
import FZCommitKit
import SnapKit

class FZDropDownBtn: UIButton, FZDropDownProtocol {
        
    // 标记展开、收起
    private var isOpen = false
    
    ///  回调选中的数据
    var didSelectTitleBlock:((String) -> Void)?
    
    ///  按钮被触发的事件
    var didDropDownBtnClickBlock:(() -> Void)?
    
    /// 是展示文字还是展示输入框
    var isShowTF: Bool = false {
        didSet {
            if isShowTF {
                bgView.isHidden = true
                stackView.snp.updateConstraints { make in
                    make.left.equalTo(leftLab.snp.right).offset(17.fit)
                }
            } else {
                phoneNoTF.isHidden = true
            }
        }
    }

    lazy var dropView: FZDropDownView = {
        let view = FZDropDownView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftLab: UILabel = {
        let lab = UILabel()
        lab.text = "渠道"
        lab.font = 10.regularPFFont
        lab.textColor = UIColor.gray
        lab.sizeToFit()
        return lab
    }()
    
    private let stackView: UIStackView = {
        let v = UIStackView(frame: .zero)
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .leading
        v.spacing = 0
        return v
    }()
    
    private lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var verLineView: UIView = {
        let view = UIView()
        view.backgroundColor = fz_hexStringColor(hexString: "#DFDFDF")
        return view
    }()
    
    private lazy var contentLab: UILabel = {
        let lab = UILabel()
        lab.font = 10.regularPFFont
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
        lab.sizeToFit()
        return lab
    }()
    
    private lazy var arrowImV: UIImageView = {
        let ImV = UIImageView()
        ImV.image = UIImage(named: "arrow_down")
        return ImV
    }()
    
    private lazy var phoneNoTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "请输入", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: 10.regularPFFont])
        return tf
    }()
    
    /// 默认内容
    var defaultValue: String = " " {
        didSet {
            contentLab.text = defaultValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(titleArr: [String]) {
        self.init()
        setupUI()
        
        if titleArr.count != 0 {
            dropView.dropDownTitleArr = titleArr
        } else {
            dropView.dropDownTitleArr = []
        }
    }
    
    private func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = 9.fit
        layer.borderWidth = 0.5.fit
        layer.borderColor = fz_hexStringColor(hexString: "#A4A4A4").cgColor
        
        addSubview(leftLab)
        addSubview(stackView)
        stackView.addArrangedSubviews([bgView, phoneNoTF])
        bgView.addSubviews([verLineView, contentLab, arrowImV])

        leftLab.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7.fit)
            make.centerY.equalToSuperview()
            make.width.lessThanOrEqualTo(35.fit)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(leftLab.snp.right)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-7.fit)
        }
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        verLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(3.fit)
            make.centerY.equalToSuperview()
            make.height.equalTo(10.fit)
            make.width.equalTo(1.fit)
        }

        contentLab.snp.makeConstraints { make in
            make.left.equalTo(verLineView.snp.right).offset(5.fit)
            make.height.centerY.equalToSuperview()
        }

        arrowImV.snp.makeConstraints { make in
            make.left.equalTo(contentLab.snp.right).offset(6.fit)
            make.width.equalTo(8.fit)
            make.height.equalTo(7.fit)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        phoneNoTF.snp.makeConstraints { make in
            make.width.equalTo(80.fit)
            make.edges.equalToSuperview()
        }
    
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = superview {
            superview.addSubview(dropView)
            superview.bringSubviewToFront(dropView)
            dropView.snp.remakeConstraints { make in
                make.top.equalTo(self.snp.bottom).offset(-7.fit)
                make.centerX.equalTo(self.snp.centerX)
                make.width.equalTo(self.snp.width)
                make.height.equalTo(0).priority(.high)
            }
            dropView.isHidden = true
        } else {
            dismissDropDown()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            if let block = self.didDropDownBtnClickBlock {
                block()
            }
            self.dropView.isHidden = false
            dropView.snp.updateConstraints { make in
                make.height.equalTo(150.fit).priority(.high)
            }
            
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
                self.dropView.setBorderWithView(top: false, left: true, bottom: true, right: true, lineWidth: 0.5.fit, color: fz_hexStringColor(hexString: "#A4A4A4"))
            }, completion: nil)
        } else {
           dismissDropDown()
        }
    }
    
    private func dismissDropDown() {
        isOpen = false
        self.dropView.isHidden = true
        
        dropView.snp.updateConstraints { make in
            make.height.equalTo(0).priority(.high)
        }
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func didClickDropDownTitle(title: String) {
        self.contentLab.text = title
        if let block = didSelectTitleBlock {
            block(title)
        }
        self.dismissDropDown()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
