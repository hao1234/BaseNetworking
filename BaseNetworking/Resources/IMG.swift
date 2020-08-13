//
//  IMG.swift
//
//  Auto Created by images.rb
//
//

import UIKit

enum IMG: String {
    
	case ic_nav_back_2
	case tab_bar_ic_chat_active
	case tab_bar_ic_chat_default
	case tab_bar_ic_income_active
	case tab_bar_ic_income_default
	case tab_bar_ic_notification_active
	case tab_bar_ic_notification_default
	case tab_bar_ic_orders_active
	case tab_bar_ic_orders_default

}

extension IMG {
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
