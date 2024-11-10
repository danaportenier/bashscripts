#!/usr/bin/env swift

import Foundation

// String extension for trimming
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// Helper function for general input
func getInput(prompt: String) -> String {
    print(prompt, terminator: ": ")
    return readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
}

// Surgery type input
func getSurgeryType() -> String {
    while true {
        print("\nPrimary Bariatric Surgery Type:")
        print("1. Gastric Bypass")
        print("2. Sleeve Gastrectomy")
        print("3. Adjustable Gastric Band")
        print("4. Duodenal Switch")
        print("5. Single Anastomosis Duodenal Ileal Bypass With Sleeve (SADI-S)")
        print("6. Vertical Banded Gastroplasty")
        print("7. Jejunal Ileal Bypass")
        print("8. One Anastomosis Gastric Bypass")
        print("9. Other")
        let input = getInput(prompt: "Enter the number of your primary bariatric surgery type")
        
        switch input {
        case "1": return "Gastric Bypass"
        case "2": return "Sleeve Gastrectomy"
        case "3": return "Adjustable Gastric Band"
        case "4": return "Duodenal Switch"
        case "5": return "Single Anastomosis Duodenal Ileal Bypass With Sleeve (SADI-S)"
        case "6": return "Vertical Banded Gastroplasty"
        case "7": return "Jejunal Ileal Bypass"
        case "8": return "One Anastomosis Gastric Bypass"
        case "9": 
            return getInput(prompt: "Please specify the surgery type")
        default:
            print("Please enter a valid option (1-9)")
        }
    }
}

// Get height input
func getHeight() -> (feet: Double, inches: Double) {
    let feet = Double(getInput(prompt: "Enter height (feet)")) ?? 0.0
    let inches = Double(getInput(prompt: "Enter height (inches)")) ?? 0.0
    return (feet, inches)
}

// Get weight history
func getWeightHistory() -> (preop: Double, lowest: Double, current: Double, lowestTiming: String, lowestMonths: Int) {
    let preop = Double(getInput(prompt: "Enter pre-op weight (lbs)")) ?? 0.0
    let lowest = Double(getInput(prompt: "Enter lowest weight achieved after surgery (lbs)")) ?? 0.0
    let current = Double(getInput(prompt: "Enter current weight (lbs)")) ?? 0.0
    
    // Get timing in months and convert to proper format
    let months = Int(getInput(prompt: "When did you achieve your lowest weight? (months after surgery)")) ?? 0
    let years = months / 12
    let remainingMonths = months % 12
    let timing = "\(years) years and \(remainingMonths) months after surgery"
    
    return (preop, lowest, current, timing, months)
}

// Modify the follow-up compliance structure to include comments
struct FollowUpInfo {
    var regular: Bool
    var regularComment: String
    var vitamins: Bool
    var vitaminsComment: String
    var labs: Bool
    var labsComment: String
}

// Modify the follow-up questions section
func getFollowUpInfo() -> FollowUpInfo {
    print("\nRegular follow-up after surgery? (y/n)", terminator: ": ")
    let regular = (readLine()?.lowercased() == "y")
    var regularComment = ""
    if !regular {
        print("Why not?", terminator: ": ")
        regularComment = readLine() ?? ""
    }
    
    print("Taking Bariatric Vitamins? (y/n)", terminator: ": ")
    let vitamins = (readLine()?.lowercased() == "y")
    var vitaminsComment = ""
    if !vitamins {
        print("Why not?", terminator: ": ")
        vitaminsComment = readLine() ?? ""
    }
    
    print("Regular bariatric labs? (y/n)", terminator: ": ")
    let labs = (readLine()?.lowercased() == "y")
    var labsComment = ""
    if !labs {
        print("Why not?", terminator: ": ")
        labsComment = readLine() ?? ""
    }
    
    return FollowUpInfo(
        regular: regular,
        regularComment: regularComment,
        vitamins: vitamins,
        vitaminsComment: vitaminsComment,
        labs: labs,
        labsComment: labsComment
    )
}

// Modify the getInitialSurgeryDetails function to remove scar and mesh questions
func getInitialSurgeryDetails() -> (details: String, complications: String, revisionReason: String) {
    let details = getInput(prompt: "Tell me about your initial bariatric surgery (length of stay, complications, readmissions, other)")
    let revisionReason = getInput(prompt: "What is your reason for pursuing revision? (press Enter for weight gain)").isEmpty ? "weight gain" : getInput(prompt: "What is your reason for pursuing revision?")
    let longTermComplications = getInput(prompt: "Any long term complications (reoperations, vitamin deficiencies, procedural related interventions)?")
    return (details, longTermComplications, revisionReason)
}

// Create new function for scar and mesh information
func getScarAndMeshInfo() -> (scars: String, mesh: String) {
    let scars = getInput(prompt: "Describe the size and location of surgical scars on your abdomen")
    let mesh = getInput(prompt: "Have you ever had surgical mesh placed in your abdomen for hernia repair? If yes, please provide details")
    return (scars, mesh)
}

// Add new function for surgery date input
func getSurgeryDate() -> String {
    var surgeryDate = ""
    
    // Get year first
    while true {
        let yearInput = getInput(prompt: "Enter surgery year (YYYY)")
        if yearInput.count == 4, let year = Int(yearInput) {
            let currentYear = Calendar.current.component(.year, from: Date())
            if year >= 1900 && year <= currentYear {
                // Get month
                let monthInput = getInput(prompt: "Enter surgery month (1-12, or press Enter)")
                let month: Int
                
                if monthInput.isEmpty {
                    month = 1 // Default to January
                } else if let m = Int(monthInput), m >= 1 && m <= 12 {
                    month = m
                } else {
                    print("Invalid month. Please enter a number between 1 and 12")
                    continue
                }
                
                // Format the date string
                surgeryDate = String(format: "%04d-%02d", year, month)
                break
            }
        }
        print("Please enter a valid year (YYYY)")
    }
    
    return surgeryDate
}

// Add function to calculate weight loss metrics
func calculateWeightMetrics(currentWeight: Double, preopWeight: Double, lowestWeight: Double, idealWeight: Double) -> String {
    let nadirWeightLoss = preopWeight - lowestWeight
    let nadirPercentTotalWeightLoss = (nadirWeightLoss / preopWeight) * 100
    let excessWeight = preopWeight - idealWeight
    let nadirPercentExcessWeightLoss = (nadirWeightLoss / excessWeight) * 100
    
    let currentWeightLoss = preopWeight - currentWeight
    let currentPercentTotalWeightLoss = (currentWeightLoss / preopWeight) * 100
    let currentPercentExcessWeightLoss = (currentWeightLoss / excessWeight) * 100
    
    return """
    Weight Loss at Lowest Weight: \(String(format: "%.1f", nadirWeightLoss)) lbs
    Percent Total Weight Loss at Lowest Weight: \(String(format: "%.1f", nadirPercentTotalWeightLoss))%
    Percent Excess Weight Loss at Lowest Weight: \(String(format: "%.1f", nadirPercentExcessWeightLoss))%
    
    Current Weight Loss: \(String(format: "%.1f", currentWeightLoss)) lbs
    Current Percent Total Weight Loss: \(String(format: "%.1f", currentPercentTotalWeightLoss))%
    Current Percent Excess Weight Loss: \(String(format: "%.1f", currentPercentExcessWeightLoss))%
    """
}

// Ideal body weight calculation
func idealBodyWeight(heightInches: Double, gender: String) -> Double {
    let baseHeight = 60.0 // 5 feet in inches
    let baseWeight = gender == "m" ? 106.0 : 100.0
    let weightPerInch = gender == "m" ? 6.0 : 5.0
    
    if heightInches <= baseHeight {
        return baseWeight
    }
    
    return baseWeight + ((heightInches - baseHeight) * weightPerInch)
}

// Calculate BMI
func calculateBMI(_ weightLbs: Double, heightMeters: Double) -> Double {
    let weightKg = weightLbs * 0.453592
    return weightKg / (heightMeters * heightMeters)
}

// Write output to file
func writeToFile(content: String, filename: String, directory: String) {
    let filePath = (directory as NSString).appendingPathComponent(filename)
    
    do {
        try content.write(toFile: filePath, atomically: true, encoding: .utf8)
        print("Content written to \(filePath)")
    } catch {
        print("Error writing to file: \(error)")
    }
}

// Format output as markdown
func formatAsMarkdown(_ output: String) -> String {
    let lines = output.components(separatedBy: "\n")
    var markdown = ""
    var isFirstSection = true
    
    for line in lines {
        if line.isEmpty { continue }
        
        if line.contains("Surgery Date") || 
           line.contains("Weight History") ||
           line.contains("Follow-up Compliance") ||
           line.contains("Revision Information") ||
           line.contains("Medical Conditions") {
            if !isFirstSection {
                markdown += "\n---\n\n"
            }
            isFirstSection = false
        }
        
        let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            markdown += "**\(parts[0].trim()):** \(parts[1].trim())\n\n"
        } else {
            markdown += "**\(line.trim())**\n\n"
        }
    }
    
    return markdown.trimmingCharacters(in: .newlines)
}

// Format output as markdown table
func formatAsMarkdownTable(_ output: String) -> String {
    let lines = output.components(separatedBy: "\n")
    var table = "| Category | Details |\n|---|---|\n"
    
    for line in lines {
        if line.isEmpty { continue }
        
        let parts = line.split(separator: ":", maxSplits: 1).map(String.init)
        if parts.count == 2 {
            table += "| \(parts[0].trim()) | \(parts[1].trim()) |\n"
        } else {
            table += "| **Section** | \(line.trim()) |\n"
        }
    }
    
    return table
}

// Copy output to clipboard using pbcopy
func copyToClipboard(_ text: String) {
    let task = Process()
    task.launchPath = "/usr/bin/pbcopy"
    let pipe = Pipe()
    task.standardInput = pipe
    let handle = pipe.fileHandleForWriting
    
    do {
        try task.run()
        handle.write(text.data(using: .utf8)!)
        handle.closeFile()
        task.waitUntilExit()
        print("\nResults copied to clipboard!")
    } catch {
        print("\nError copying to clipboard: \(error)")
    }
}

func getOutputFormat() -> String {
    while true {
        let format = getInput(prompt: "Output format? (m=markdown, mt=markdown table, or press Enter for text)").lowercased()
        if format.isEmpty || format == "t" {
            return "t"
        }
        if ["m", "mt"].contains(format) {
            return format
        }
        print("Please enter 'm' for markdown, 'mt' for markdown table, or press Enter for plain text")
    }
}

// Add these functions before the main program execution section
func calculateAge(birthMonth: Int, birthDay: Int, birthYear: Int) -> Int {
    let calendar = Calendar.current
    let currentDate = Date()
    let birthDate = calendar.date(from: DateComponents(year: birthYear, month: birthMonth, day: birthDay))!
    let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
    return ageComponents.year ?? 0
}

func getBirthDate() -> (age: Int, dateString: String) {
    while true {
        print("Enter birth month (1-12)", terminator: ": ")
        guard let month = Int(readLine() ?? ""), (1...12).contains(month) else {
            print("Invalid month. Please enter a number between 1 and 12.")
            continue
        }
        
        print("Enter birth day (1-31)", terminator: ": ")
        guard let day = Int(readLine() ?? ""), (1...31).contains(day) else {
            print("Invalid day. Please enter a number between 1 and 31.")
            continue
        }
        
        print("Enter birth year (YYYY)", terminator: ": ")
        guard let year = Int(readLine() ?? ""), (1900...Calendar.current.component(.year, from: Date())).contains(year) else {
            print("Invalid year. Please enter a valid year.")
            continue
        }
        
        let age = calculateAge(birthMonth: month, birthDay: day, birthYear: year)
        let dateString = String(format: "%02d/%02d/%04d", month, day, year)
        return (age, dateString)
    }
}

// Add this function before getBirthDate()
func getGender() -> String {
    while true {
        print("Enter gender (m/f)", terminator: ": ")
        if let input = readLine()?.lowercased(), ["m", "f"].contains(input) {
            return input
        }
        print("Invalid input. Please enter 'm' for male or 'f' for female.")
    }
}

// Add this function to calculate age at surgery
func calculateAgeAtSurgery(birthDate: String, surgeryDate: String) -> Int {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    
    guard let birthDateTime = dateFormatter.date(from: birthDate),
          let surgeryDateTime = dateFormatter.date(from: surgeryDate + "/01") else {
        return 0
    }
    
    let calendar = Calendar.current
    let ageComponents = calendar.dateComponents([.year], from: birthDateTime, to: surgeryDateTime)
    return ageComponents.year ?? 0
}

// Add these calculation functions
func calculateEWL(initialWeight: Double, targetWeight: Double, idealWeight: Double) -> Double {
    let excessWeight = initialWeight - idealWeight
    let weightLoss = initialWeight - targetWeight
    return (weightLoss / excessWeight) * 100
}

func calculateTWL(initialWeight: Double, targetWeight: Double) -> Double {
    return ((initialWeight - targetWeight) / initialWeight) * 100
}

// Add a helper function for the conversion
func lbsToKg(_ lbs: Double) -> Double {
    return lbs / 2.20462
}

// Add this new struct for medical history
struct MedicalCondition {
    let name: String
    let hasCondition: Bool
    let details: String
}

// Add this new function to get medical history
func getMedicalHistory() -> [MedicalCondition] {
    let conditions = [
        "CAD/MI/CHF/Stroke",
        "Deep Vein Thrombosis (DVT) / Pulmonary Embolism (PE)",
        "Clotting Disorders",
        "Blood Thinners (e.g., Coumadin, Eliquis, Xarelto)",
        "Any respiratory conditions (OSA, home O2, COPD)",
        "Gastroesophageal Reflux Disease (GERD)",
        "Liver Disease (e.g., Nonalcoholic Fatty Liver Disease or Cirrhosis)",
        "Diabetes Mellitus",
        "Chronic Kidney Disease (CKD)",
        "Anemia",
        "Osteoarthritis or Degenerative Joint Disease",
        "Immobility or Limited Mobility",
        "Immune Disorders or Chronic Infections",
        "Malnutrition or Nutritional Deficiencies",
        "Currently taking chronic Opioids",
        "Currently taking non-steroidal anti-inflammatory drugs (NSAIDs)",
        "Currently taking steroids (e.g., Prednisone)",
        "Currently taking GLP-1 agents (Ozempic, Mounjaro, Wegovy, Zepbound)"
    ]
    
    var medicalHistory: [MedicalCondition] = []
    
    print("\nPast Medical History:")
    for condition in conditions {
        if condition == "CAD/MI/CHF/Stroke" {
            print("\nDo you have any history of CAD, MI, CHF, or Stroke? (y/n)", terminator: ": ")
        } else if condition.contains("GLP-1") {
            print("\nAre you taking any GLP-1 medications (Ozempic, Mounjaro, Wegovy, Zepbound)? (y/n)", terminator: ": ")
        } else {
            print("\nDo you have/take \(condition)? (y/n)", terminator: ": ")
        }
        
        let hasCondition = (readLine()?.lowercased() == "y")
        var details = ""
        
        if hasCondition {
            if condition == "CAD/MI/CHF/Stroke" {
                print("Please specify which condition(s) and details (or press Enter to skip)", terminator: ": ")
            } else if condition.contains("GLP-1") {
                print("Which medication and dose? (or press Enter to skip)", terminator: ": ")
            } else {
                print("Enter details (or press Enter to skip)", terminator: ": ")
            }
            details = readLine()?.trim() ?? ""
        }
        
        let outputName = if condition == "CAD/MI/CHF/Stroke" {
            "Coronary Artery Disease (CAD), Heart Attack (MI), Congestive Heart Failure (CHF), or Stroke"
        } else if condition.contains("GLP-1") {
            "GLP-1 agents (Ozempic, Mounjaro, Wegovy, Zepbound)"
        } else {
            condition
        }
        
        medicalHistory.append(MedicalCondition(
            name: outputName,
            hasCondition: hasCondition,
            details: details
        ))
    }
    
    return medicalHistory
}

// Main program execution
print("Bariatric Surgery Revision Calculator\n")

// Get birth date information first
let (patientAge, birthDate) = getBirthDate()

// Get gender before height and weight info
let gender = getGender()

// Get surgery date and calculate time since surgery
let surgeryDate = getSurgeryDate()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM"

var formattedDate = ""
var yearsSinceSurgery = 0
var monthsSinceSurgery = 0

if let date = dateFormatter.date(from: surgeryDate) {
    // Format the date for display
    dateFormatter.dateFormat = "MMMM yyyy"
    formattedDate = dateFormatter.string(from: date)
    
    // Calculate time since surgery
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month], from: date, to: Date())
    yearsSinceSurgery = components.year ?? 0
    monthsSinceSurgery = components.month ?? 0
}

// Calculate age at surgery
let ageAtSurgery = calculateAgeAtSurgery(birthDate: birthDate, surgeryDate: surgeryDate)

// Get basic surgery info
let surgeryType = getSurgeryType()
let approach = getInput(prompt: "Was the surgery Laparoscopic or Open? (l/o)").lowercased() == "l" ? "Laparoscopic" : "Open"
let surgeryLocation = getInput(prompt: "Where was your surgery done?")
    .split(separator: " ")
    .map { $0.capitalized }
    .joined(separator: " ")
let surgeon = getInput(prompt: "Who was your Surgeon? Dr.").capitalized

// Get height and weight info
let height = getHeight()
let totalInches = (height.feet * 12) + height.inches
let heightMeters = totalInches * 0.0254
let weights = getWeightHistory()

// Calculate BMIs
let preopBMI = calculateBMI(weights.preop, heightMeters: heightMeters)
let lowestBMI = calculateBMI(weights.lowest, heightMeters: heightMeters)
let currentBMI = calculateBMI(weights.current, heightMeters: heightMeters)

// After getting height and weight info, calculate ideal body weight
let ibw = idealBodyWeight(heightInches: totalInches, gender: gender)

// Get initial surgery details right after weight
let initialSurgeryInfo = getInitialSurgeryDetails()

// Get follow-up information
let followUp = getFollowUpInfo()

// Get revision information
let conditions = getInput(prompt: "List any obesity-related medical conditions that improved but have returned")

// Calculate %EWL and %TWL for both lowest and current weights
let nadirEWL = calculateEWL(initialWeight: weights.preop, targetWeight: weights.lowest, idealWeight: ibw)
let currentEWL = calculateEWL(initialWeight: weights.preop, targetWeight: weights.current, idealWeight: ibw)
let nadirTWL = calculateTWL(initialWeight: weights.preop, targetWeight: weights.lowest)
let currentTWL = calculateTWL(initialWeight: weights.preop, targetWeight: weights.current)

// Add this in the main program execution section before creating the output string
let medicalHistory = getMedicalHistory()

// Create new function for scar and mesh information
let scarAndMeshInfo = getScarAndMeshInfo()

// Modify the output string to reflect the new order:
var output = """
Birth Date: \(birthDate)
Age: \(patientAge) years old \(gender == "m" ? "male" : "female")

Date of Surgery: \(formattedDate)
Primary Bariatric Surgery: \(approach) \(surgeryType)
Location: \(surgeryLocation)
Surgeon: Dr. \(surgeon)

Initial Surgery Details: \(initialSurgeryInfo.details)
Reason for Revision: \(initialSurgeryInfo.revisionReason)
Long Term Complications: \(initialSurgeryInfo.complications)

Past Medical History:
\(medicalHistory.map { condition in 
    if condition.hasCondition {
        let details = condition.details.isEmpty ? "" : " - \(condition.details)"
        return "\(condition.name): Yes\(details)"
    }
    return "\(condition.name): No"
}.joined(separator: "\n"))

Surgical History:
Surgical Scars: \(scarAndMeshInfo.scars)
Abdominal Mesh History: \(scarAndMeshInfo.mesh)

Height: \(Int(height.feet))'\(Int(height.inches))" (\(String(format: "%.2f", heightMeters)) m)

Weight History:
Ideal Body Weight: \(String(format: "%.1f", ibw)) lbs (\(String(format: "%.1f", lbsToKg(ibw))) Kg)
Pre-op Weight: \(String(format: "%.1f", weights.preop)) lbs (\(String(format: "%.1f", lbsToKg(weights.preop))) Kg) (BMI: \(String(format: "%.1f", preopBMI)))
Lowest Weight: \(String(format: "%.1f", weights.lowest)) lbs (\(String(format: "%.1f", lbsToKg(weights.lowest))) Kg) (BMI: \(String(format: "%.1f", lowestBMI)))
Timing of Lowest Weight: \(weights.lowestTiming)
Current Weight: \(String(format: "%.1f", weights.current)) lbs (\(String(format: "%.1f", lbsToKg(weights.current))) Kg) (BMI: \(String(format: "%.1f", currentBMI)))

Weight Loss Metrics:
Total Weight Loss at Lowest: \(String(format: "%.1f", weights.preop - weights.lowest)) lbs (\(String(format: "%.1f", lbsToKg(weights.preop - weights.lowest))) Kg)
%EWL at Lowest Weight: \(String(format: "%.1f", nadirEWL))%
%TWL at Lowest Weight: \(String(format: "%.1f", nadirTWL))%

Current Weight Regain: \(String(format: "%.1f", weights.current - weights.lowest)) lbs (\(String(format: "%.1f", lbsToKg(weights.current - weights.lowest))) Kg)
Current %EWL: \(String(format: "%.1f", currentEWL))%
Current %TWL: \(String(format: "%.1f", currentTWL))%

Follow-up Compliance:
Regular follow-up after surgery: \(followUp.regular ? "Yes" : "No\(followUp.regularComment.isEmpty ? "" : " - \(followUp.regularComment)")")
Taking Bariatric Vitamins: \(followUp.vitamins ? "Yes" : "No\(followUp.vitaminsComment.isEmpty ? "" : " - \(followUp.vitaminsComment)")")
Regular bariatric labs: \(followUp.labs ? "Yes" : "No\(followUp.labsComment.isEmpty ? "" : " - \(followUp.labsComment)")")

Revision Information:
Reason for Revision: \(revisionReason)

Medical Conditions That resolved or improved after bariatric surgery that have returned or worsened:
\(conditions)

We discussed the risks of revisional bariatric surgery.  The dangers of surgery and long terms care complications after surgery discussed at your primary bariatric surgery all still exist and occur at similar rates of occurrence. Our team will discuss these fully again in our preop bariatric class, which is mandatory before surgery.

Also, bariatric surgery will have increased peri-operative risk associated with the scarring related to the previous surgery.  This can increase the risk of complications 3-5% above and beyond the primary bariatric surgery baseline per review in the medical literature.  

This increased risk should be carefully considered when ultimately deciding whether to have revisional surgery or pursue the nonsurgical alternatives.  

Each revisional surgical option presented will have subtle differences but will require more vitamins to be taken for life after surgery and mandatory follow-up for life.  

Path to revision would include:
 
1. Bariatric Revision benefits determination triggered by completing online application
2. Surgeon Initial Visit
3. Start mandatory 3 month medical weight loss with primary car physician
4. Anatomy Evaluation.  Typically done by endoscopy or x-ray test called upper GI.
5. Patient to be given revision options ranging from non-surgical to surgical with interval period to research.
6. Discussion of options and guidance in the decision to proceed or not towards revision. Detailed risk discussion tailored to patient specifics
7. If pursuing surgery, will have to attend our revision class and determine the workup required for clearance and risk reduce for surgery
8. Once adequately cleared and prepared for surgery, submit for insurance pre-authorization
9. Preoperative Classes
10. Surgery
11. Post-op class and life-long followup required


Discussed that we are on step 2 today next steps will be step 3 and 4.  Our team will reach out to set up an endoscopy.  Patient will be sent education materials about bariatric surgery, risk of revision surgery, and revision options.

Dana Portenier
"""

// Print the output
print(output)

// Get user's format choice
let format = getOutputFormat()
let formattedOutput = switch format {
    case "m":  formatAsMarkdown(output)
    case "mt": formatAsMarkdownTable(output)
    default:   output
}

let outputDirectory = "/Users/danaportenier/Desktop/DraftNotes"

// Create all three format versions
let plainOutput = output
let markdownOutput = formatAsMarkdown(output)
let markdownTableOutput = formatAsMarkdownTable(output)

// Write all three formats to files
writeToFile(content: plainOutput, filename: "plain.txt", directory: outputDirectory)
writeToFile(content: markdownOutput, filename: "markdown.md", directory: outputDirectory)
writeToFile(content: markdownTableOutput, filename: "markdownTable.md", directory: outputDirectory)

// Display and copy to clipboard the user's chosen format
print(formattedOutput)
copyToClipboard(formattedOutput)
