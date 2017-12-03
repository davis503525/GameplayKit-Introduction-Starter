//
//  PointsNode.swift
//  GameplayKit Introduction
//
//  Created by Davis Allie on 26/07/2015.
//  Copyright © 2015 Davis Allie. All rights reserved.
//

import UIKit

class PointsNode: ContactNode {

    override init() {
        super.init()
        entity = Points()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        entity = Points()
    }

}
