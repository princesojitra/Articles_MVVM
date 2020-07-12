//
//  CustomLoader.swift
//  Events
//
//  Created by Prince Sojitra on 19/09/19.
//  Copyright © 2019 Prince Sojitra. All rights reserved.

import Foundation
import Foundation
import UIKit

class CustomLoader : NSObject {
    
    private override init() { }
    
    static let shared:CustomLoader  = CustomLoader()
    static let customLoaderTag = 101331303
    var vwLoader:UIView?
    
    //show uiactivity indicator
    func showLoader(color:UIColor = AppColor.Color_NavyBlue) {
        
        self.vwLoader = UIView.init(frame: UIScreen.main.bounds)
        self.vwLoader?.backgroundColor =  UIColor.clear
        self.vwLoader?.clipsToBounds = true
        self.vwLoader?.tag = CustomLoader.customLoaderTag
        var activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityIndicator  = UIActivityIndicatorView(style: .whiteLarge)
        }
        activityIndicator.color = color
        activityIndicator.center = self.vwLoader!.center
        
        self.vwLoader?.addSubview(activityIndicator)
        self.vwLoader?.bringSubviewToFront(activityIndicator)
        
        DispatchQueue.main.async {
            activityIndicator.startAnimating()
        }
        Constants.appDelegate.window?.addSubview( self.vwLoader!)
        Constants.appDelegate.window?.bringSubviewToFront(self.vwLoader!)
        
    }
    
    //hide uiactivity indicator
    func hideLoader(SuperView:UIView? = nil) {
        
        guard Constants.appDelegate.window != nil else {return}
        
        //if its main threrad then hide loader else get the main thread from gloabal queue and update ui on main thread to prevent app crash
        if Thread.isMainThread {
            if let viewLoader = Constants.appDelegate.window!.viewWithTag(CustomLoader.customLoaderTag) {
                viewLoader.removeFromSuperview()
                self.vwLoader = nil
            }
        } else {
            DispatchQueue.global(qos: .default).async {
                DispatchQueue.main.sync {
                    if let viewLoader = Constants.appDelegate.window!.viewWithTag(CustomLoader.customLoaderTag) {
                        viewLoader.removeFromSuperview()
                        self.vwLoader = nil
                    }
                    
                }
            }
        }
    }
    
    //Check subivews and remove it if any exist
    func listSubviews(view: UIView,tagtoRemove:Int) {
        // Get the subviews of the view
        let subviews = view.subviews
        // Return if there are no subviews
        if subviews.count == 0 {
            return
        }
        for subview: UIView in subviews {
            if subview.tag == tagtoRemove {
                subview.removeFromSuperview()
            }
        }
    }
}
