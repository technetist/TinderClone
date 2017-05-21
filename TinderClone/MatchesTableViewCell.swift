//
//  MatchesTableViewCell.swift
//  TinderClone
//
//  Created by Adrien Maranville on 5/20/17.
//  Copyright © 2017 Adrien Maranville. All rights reserved.
//

import UIKit
import Parse

class MatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var lblMatchId: UILabel!
    @IBOutlet weak var imgMatch: UIImageView!
    @IBOutlet weak var lblConversation: UILabel!
    @IBOutlet weak var txtBoxResponse: UITextField!
    @IBAction func btnSendPressed(_ sender: Any) {
        print(lblMatchId.text!)
        print(lblConversation.text!)
        
        let message = PFObject(className: "Message")
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = lblMatchId.text
        message["content"] = txtBoxResponse.text
        
        message.saveInBackground()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
