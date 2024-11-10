#!/usr/bin/env swift

import Foundation
import AppKit  // Access NSPasteboard

func getInput(prompt: String) -> String {
    print(prompt, terminator: ": ")
    return readLine() ?? ""
}

func getGenderInput() -> String {
    while true {
        print("Enter gender (f/m)", terminator: ": ")
        if let input = readLine()?.lowercased(), input == "f" || input == "m" {
            return input
        }
        print("Invalid input. Please enter 'f' for female or 'm' for male.")
    }
}

func calculateBMI(weightKg: Double, heightMeters: Double) -> (Double, String) {
    let bmi = weightKg / (heightMeters * heightMeters)
    let classification: String

    switch bmi {
    case ..<18.5:
        classification = "Underweight"
    case 18.5..<24.9:
        classification = "Normal weight"
    case 25.0..<29.9:
        classification = "Overweight"
    case 30.0..<34.9:
        classification = "Obesity I"
    case 35.0..<39.9:
        classification = "Obesity II"
    default:
        classification = "Obesity III"
    }

    return (bmi, classification)
}

func idealBodyWeight(heightInches: Double, gender: String) -> Double {
    let baseWeightKg = (gender == "m") ? 50.0 : 45.5
    let additionalWeightKg = (heightInches - 60) * 2.3
    let idealWeightKg = baseWeightKg + additionalWeightKg
    return idealWeightKg * 2.20462 // Convert kg to lbs
}

func monthsBetween(start: Date, end: Date) -> (Int, Int) {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: start, to: end)
    return (components.year ?? 0, components.month ?? 0)
}

// Input
let feet = Double(getInput(prompt: "Enter height (feet)")) ?? 0.0
let inches = Double(getInput(prompt: "Enter height (inches)")) ?? 0.0
let totalInches = (feet * 12) + inches
let heightMeters = totalInches * 0.0254

let gender = getGenderInput()
let idealWeightLbs = idealBodyWeight(heightInches: totalInches, gender: gender)
let idealWeightKg = idealWeightLbs / 2.20462 // Convert lbs to kg

let weightLbs = Double(getInput(prompt: "Enter current weight (lbs)")) ?? 0.0
let weightKg = weightLbs * 0.453592

let (currentBMI, currentClassification) = calculateBMI(weightKg: weightKg, heightMeters: heightMeters)

// Calculate current excess weight
let currentExcessWeightLbs = weightLbs - idealWeightLbs

let hadSurgery = getInput(prompt: "Have you had bariatric surgery? (y/n)").lowercased()
var preopWeightLbs: Double = 0.0
var yearsSinceSurgery = 0
var monthsSinceSurgery = 0
var preopBMI: Double = 0.0
var preopClassification: String = ""

if hadSurgery == "y" {
    preopWeightLbs = Double(getInput(prompt: "Enter pre-op weight (lbs)")) ?? 0.0
    
    let surgeryMonth = Int(getInput(prompt: "Enter surgery month (1-12)")) ?? 0
    let surgeryDay = Int(getInput(prompt: "Enter surgery day (1-31)")) ?? 0
    let surgeryYear = Int(getInput(prompt: "Enter surgery year (e.g., 2023)")) ?? 0
    
    let dateComponents = DateComponents(year: surgeryYear, month: surgeryMonth, day: surgeryDay)
    if let surgeryDate = Calendar.current.date(from: dateComponents) {
        let (years, months) = monthsBetween(start: surgeryDate, end: Date())
        yearsSinceSurgery = years
        monthsSinceSurgery = months
    } else {
        print("Invalid date entered. Using current date.")
    }
    
    let preopWeightKg = preopWeightLbs * 0.453592
    (preopBMI, preopClassification) = calculateBMI(weightKg: preopWeightKg, heightMeters: heightMeters)
}

let genderOutput = gender == "m" ? "Male" : "Female"

var output = """
Age: *** years old 
Height: \(Int(feet)) ft \(Int(inches)) in (\(Int(totalInches)) in total, \(String(format: "%.2f", heightMeters)) m)
Gender: \(genderOutput)
Ideal Body Weight: \(String(format: "%.2f", idealWeightLbs)) lbs (\(String(format: "%.2f", idealWeightKg)) kg)
Current Weight: \(weightLbs) lbs (\(String(format: "%.2f", weightKg)) kg)
Current BMI: \(String(format: "%.2f", currentBMI)) (\(currentClassification))
Current Excess Weight: \(String(format: "%.2f", currentExcessWeightLbs)) lbs
"""

print(output)

if hadSurgery == "y" {
    let preopWeightKg = preopWeightLbs * 0.453592
    let excessWeightLbs = preopWeightLbs - idealWeightLbs
    let currentExcessWeightLbs = weightLbs - idealWeightLbs
    let percentExcessWeightLoss = (excessWeightLbs - currentExcessWeightLbs) / excessWeightLbs * 100
    
    let weightLostLbs = preopWeightLbs - weightLbs
    let weightLostKg = weightLostLbs * 0.453592

    let deltaBMI = preopBMI - currentBMI

    let timeSinceSurgery = (yearsSinceSurgery > 0) ? "\(yearsSinceSurgery) years and \(monthsSinceSurgery) months" : "\(monthsSinceSurgery) months"

    let surgeryOutput = """

Pre-op Weight: \(String(format: "%.2f", preopWeightLbs)) lbs (\(String(format: "%.2f", preopWeightKg)) kg)
Pre-op BMI: \(String(format: "%.2f", preopBMI)) (\(preopClassification))
Current BMI: \(String(format: "%.2f", currentBMI)) (\(currentClassification))
ΔBMI: \(String(format: "%.2f", deltaBMI))
Time Since Surgery: \(timeSinceSurgery)
Weight Lost: \(String(format: "%.2f", weightLostLbs)) lbs (\(String(format: "%.2f", weightLostKg)) kg)
Percent Excess Weight Loss: \(String(format: "%.2f", percentExcessWeightLoss))%
Excess Weight (Pre-op): \(String(format: "%.2f", excessWeightLbs)) lbs
Current Excess Weight: \(String(format: "%.2f", currentExcessWeightLbs)) lbs
"""
    print(surgeryOutput)
    output += surgeryOutput
}

// Copy to Clipboard
let pasteboard = NSPasteboard.general
pasteboard.clearContents()
pasteboard.setString(output, forType: .string)

print("\nResults copied to clipboard!")
