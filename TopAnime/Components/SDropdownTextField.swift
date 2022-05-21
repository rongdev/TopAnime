//
//  SDropdownTextField.swift
//  TopAnime
//
//  Created by Jenny on 2022/5/19.
//

import Foundation
import UIKit

private let kNormalBackgroundColor: UIColor = UIColor(rgbaValue: 0xe5e8f0f0)
private let kHighLightAnimationTime: Double = 0.15
private let kIconEdgeLeading: CGFloat = 9.0
private let kIconEdgeTrailing: CGFloat = 9.0
private let kIconWt: CGFloat = 24.0
private let kIconHt: CGFloat = 44.0
private let kEdgeLeading: CGFloat = 9.0

typealias SOnePickCompletion = ((_ index: Int, _ text: String) -> Void)

enum SDropdownType: Int {
    case `default` = 0
    case onePicker
    
    var pickerColNumber: Int {
        switch self {
        case .onePicker: return 1
        default: return 0
        }
    }
}

class SDropdownTextField: UITextField {
    lazy private var picker = UIPickerView()
    lazy private var ivIcon = UIImageView(frame: CGRect(x: 0,
                                                          y: 0,
                                                          width: kIconWt,
                                                          height: kIconHt))

    lazy private var aryPickerItem: [String] = []
    lazy private var iPkSelectedCol: Int = 0
    lazy private var iPkSelectedRow: Int = 0
    var onePickCompletion: SOnePickCompletion? = nil
    
    var type: SDropdownType = .default {
        didSet {
            if type == .onePicker {
                setOnePickerParam()
            }
            
            if type == .default {
                rightIconOn = nil
            } else {
                rightIconOn = UIImage.dropdownOn
            }
        }
    }
    
    private var rightIconOn: UIImage? = nil {
        didSet {
            var vContainer: UIView?
            
            if rightIconOn == nil {
                vContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: kIconEdgeTrailing,
                                                  height: kIconHt))
            } else {
                ivIcon.image = rightIconOn
                ivIcon.contentMode = .center
                
                vContainer = UIView(frame: CGRect(x: 0, y: 0,
                                                  width: kIconWt + kIconEdgeTrailing,
                                                  height: kIconHt))
                vContainer?.addSubview(ivIcon)
            }
            
            rightView = vContainer
            rightView?.isUserInteractionEnabled = false
            rightViewMode = .always
        }
    }
    
    // MARK: IBInspectable
    @IBInspectable var dropdownType: Int = 0 {
        didSet {
            type = SDropdownType(rawValue: dropdownType) ?? .default
        }
    }
    
    // MARK: Public Methods
    func setOnePickerParam(aryItem: [String] = [],
                           completion: SOnePickCompletion? = nil) {
        aryPickerItem = aryItem
        onePickCompletion = completion
        picker.reloadAllComponents()
    }
    
    // MARK: - Initialization
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    // MARK: Init Methods
    private func initView() {
        font = UIFont.systemFont(ofSize: 14, weight: .regular)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: kEdgeLeading, height: kIconHt))
        leftViewMode = .always
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
    }
 
    @objc private func handleEditingDidBegin() {
        if type == .default {
            inputView = nil
        } else if type == .onePicker {
            picker.dataSource = self
            picker.delegate = self
            
            inputView = picker
        }
    }
    
    @objc private func handleEditingDidEnd() {
        if type == .onePicker {
            guard iPkSelectedRow < aryPickerItem.count else {
                return
            }
            
            text = aryPickerItem[iPkSelectedRow]
            onePickCompletion?(iPkSelectedRow, aryPickerItem[iPkSelectedRow])
        }
    }
    
    // MARK: Hide Focus
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) ||
            action == #selector(cut(_:)) ||
            action == #selector(delete(_:)) ||
            action == #selector(selectAll(_:)) ||
            action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
    
}

extension SDropdownTextField: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return type.pickerColNumber
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.bounds.size.width
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return aryPickerItem[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return aryPickerItem.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        iPkSelectedCol = component
        iPkSelectedRow = row
    }
}
