import Foundation

let albumName = "bariatric procedures"

// AppleScript command to open the Photos app and navigate to a specific album
let appleScript = """
tell application "Photos"
    activate
    delay 1
    open album "\(albumName)"
end tell
"""

// Execute the AppleScript via osascript
let task = Process()
task.launchPath = "/usr/bin/osascript"
task.arguments = ["-e", appleScript]

task.launch()
task.waitUntilExit()

let status = task.terminationStatus
if status == 0 {
    print("Successfully opened album '\(albumName)'.")
} else {
    print("Failed to open album '\(albumName)'.")
}
