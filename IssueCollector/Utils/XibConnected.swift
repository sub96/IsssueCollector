//
//  XibConnected.swift
//  Peeqaboo
//
//  Created by Suhaib Al Saghir on 14/03/2019.
//  Copyright © 2019 DTT. All rights reserved.
//

import UIKit

protocol XibConnected: class { }

extension XibConnected where Self: UIView {
    func connectXib(to containerview: UIView) {
        self.backgroundColor = .clear
        let view = self.loadNib()
        view.frame = containerview.bounds
        containerview.addSubview(view)
        view.constraint(to: containerview)
    }

    /** Loads instance from nib with the same name. */
    private func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView //swiftlint:disable:this force_cast
    }
}
