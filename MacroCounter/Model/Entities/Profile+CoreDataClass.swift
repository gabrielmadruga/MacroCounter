//
//  Profile+CoreDataClass.swift
//  MacroCounter
//
//  Created by Gabriel Madruga on 4/4/20.
//  Copyright © 2020 Gabriel Madruga. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {
    
    var weight: Float {
        currentWeight!.value
    }
    
    var bmr: Float {
        // Nowadays, the Mifflin-St Jeor equation is believed to give the most accurate result and, is therefore what we use in this app. This BMR formula is as follows:
        //BMR (kcal / day) = 10 * weight (kg) + 6.25 * height (cm) – 5 * age (y) + s (kcal / day),
        //where s is +5 for males and -161 for females.
        
        let s: Float = isMale ? 5.0 : -161.0
        let age = Float(Calendar.current.dateComponents([.year], from: birthday!, to: Date()).year!)
        let weight = currentWeight!.value
        let weightComponent = Float(10.0 * weight)
        let heightComponent = 6.25 * Float(height)
        let ageComponent = 5.0 * age
        return weightComponent + heightComponent - ageComponent + s
    }
    
    var tee: Float {
        return bmr * physicalActivityLevel
    }
}
