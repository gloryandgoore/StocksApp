//
//  MyTableViewCell.swift
//  StocksApp
//
//  Created by Caseyann Goore on 2022-10-18.
//

import UIKit

class MyTableViewCell: UITableViewCell {

        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
       
    func configureCell(item : MyStocks)  {
        //set name/ticker label
        //set stck price
        textLabel?.text = item.name
        detailTextLabel?.text = "Price..."
        if stockName = item.name{
            let headers = [
                "X-RapidAPI-Key": "c6d174dc42msh926955b2f690e00p1e37fdjsn6b6fedb2172d",
                "X-RapidAPI-Host": "ms-finance.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://ms-finance.p.rapidapi.com/market/v2/auto-complete?q=tesla")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                }
            })
            //DispatchQueue.main.async {
            //            self.detailTextLabel?.text =
            //            DispatchQueue.main.async {
            //            self.textLabel?.text =
            
            
            dataTask.resume()
        }
    }
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }

    }

