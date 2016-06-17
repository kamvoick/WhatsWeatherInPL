//
//  ViewController.swift
//  JakaPogoda
//
//  Created by Kamil Wójcik on 14.05.2016.
//  Copyright © 2016 Kamil Wójcik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var jakaJestPogodaLbl: UILabel!
    @IBOutlet weak var wpiszMiastoLbl: UILabel!
    @IBOutlet weak var wpiszMiastoTextLbl: UITextField!
    @IBOutlet weak var opisLbl: UILabel!
    
    var powiodłoSię = false
    var miasto: String!
    var pogoda: String!
    var polskieZnaki = ["ą":"a", "ę":"e", "ż":"z", "Ż":"Z", "ź":"z", "Ź":"Z", "ó":"o", "ł":"l", "Ł":"L", "ć":"c", "ń":"n", "ś":"s", "Ś":"S"]
    
    @IBAction func sprawdźPogodęBtn(sender: AnyObject) {
        if wpiszMiastoTextLbl.text != nil && wpiszMiastoTextLbl.text != "" {
            for (polskiZnak, znak) in polskieZnaki {
                if wpiszMiastoTextLbl.text?.containsString("\(polskiZnak)") == true{
                    miasto = wpiszMiastoTextLbl.text?.stringByReplacingOccurrencesOfString("\(polskiZnak)", withString: znak)
                    for (polskiZnak, znak) in polskieZnaki {
                        if miasto!.containsString("\(polskiZnak)") == true{
                            var miasto2 = miasto!.stringByReplacingOccurrencesOfString("\(polskiZnak)", withString: znak) //wiem wiem DRY, ale mam nadzieje że nikt nie będzie sprawdzał łękołody, po za tym późno już
                            for (polskiZnak, znak) in polskieZnaki {
                                if miasto2.containsString("\(polskiZnak)") == true{
                                    var miasto3 = miasto2.stringByReplacingOccurrencesOfString("\(polskiZnak)", withString: znak) //wiem wiem DRY, ale mam nadzieje że nikt nie będzie sprawdzał gorszych rzeczy niż łódź, po za tym późno już
                                    miasto2 = miasto3
                                    break
                                }// nie wygląda to fajnie, trzeba będzie to zmienić wyżej, bo nadziubane
                            }
                            miasto = miasto2
                            break
                        }
                    }
                    break
                }else{
                    miasto = wpiszMiastoTextLbl.text
                }
            }
            
        }
        prognoza()
        wpiszMiastoTextLbl.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        opisLbl.text = ""
    }
    
    func prognoza() {
        let spodziewanyUrl = NSURL(string: "http://www.meteoprog.pl/pl/weather/\(miasto.stringByReplacingOccurrencesOfString(" ", withString: ""))/")
        if let url = spodziewanyUrl {
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
                
                if let responseData = data {
                    let webContent = NSString(data: responseData, encoding: NSUTF8StringEncoding)
                    let websiteArray = webContent?.componentsSeparatedByString("<div class=\"infoPrognosis widthProg\">")
                    if websiteArray?.count > 1 {
                        self.powiodłoSię = true
                        let websiteArray2 = websiteArray![1].componentsSeparatedByString("</div>")
                        if websiteArray2[0].containsString("<br/>"){
                            let websiteArray3 = websiteArray2[0].componentsSeparatedByString("<br/>")
                            let tekstPrognozy = NSString(string: websiteArray3[0]+websiteArray3[1])
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.opisLbl.text = "\(tekstPrognozy.substringFromIndex(17))"
                            })
                        }else{
                            let tekstPrognozy = NSString(string: websiteArray2[0])
                            dispatch_async(dispatch_get_main_queue(), {
                                self.opisLbl.text = "\(tekstPrognozy.substringFromIndex(17))"
                            })
                        }
                        
                    }
                    if self.powiodłoSię == false{
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.opisLbl.text = "Nie znaleziono pogody dla podanego miasta, spróbuj ponownie."
                        })
                        
                    }
                }
                
                }.resume()
        }else{
            dispatch_async(dispatch_get_main_queue(), {
                self.opisLbl.text = "Nie znaleziono pogody dla podanego miasta, spróbuj ponownie."
            })        }
        self.powiodłoSię = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

