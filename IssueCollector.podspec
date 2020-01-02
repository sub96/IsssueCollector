
Pod::Spec.new do |spec|

  spec.name         = "IssueCollector"
  spec.version      = "0.0.3"
  spec.summary      = "Report Issues to Jira easily"

  spec.description  = <<-DESC
This CocoaPods library helps you report issues to jira with just a screenshot!
                   DESC

  spec.homepage     = "https://github.com/sub96/IsssueCollector"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Suhaib Al Saghir" => "suhaib.dtt@gmail.com" }

  spec.ios.deployment_target = "11.0"
  spec.swift_version = "4.2"

  spec.source        = { :git => "https://github.com/sub96/IsssueCollector.git", :tag => "#{spec.version}" }
  spec.source_files  = "IssueCollector/**/*.{h,m,swift}"

end