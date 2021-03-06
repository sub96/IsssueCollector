# IssueCollector
The IssueCollector is a tool that make's easy to report issues on Jira!
### Installation
Decalare the IssueCollector in your Podfile
``` Swift
pod 'IssueCollector'
```
### How to use
In AppDelegate.swift, just import IssueCollector framework and call the start observing function.

``` Swift
import IssueCollector

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  
  IssueCollector.shared.startObserving(with: .shake, 
                                       enableRecording: false, 
                                       projectKey: "ICIDEV")
  return true
}
```

| Parameter                                      | Description                  |
|------------------------------------------------|------------------------------|
| `Gesture`                                      | The gesture that will start the flow |
| `ProjectKey`                                   | The key of the project that you find on Jira.  |
| `enableRecording`                              | Boolean that allow you to record video and report it on Jira. If you want to use this feature, you have to make sure to give privacy permisssion in your info.plist |

### First usage

The first time you use this library, it will be asked to login with your Jira account and to select your workspace
