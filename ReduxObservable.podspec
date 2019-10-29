Pod::Spec.new do |spec|
    spec.name           = "ReduxObservable"
    spec.version        = "1.0.0"
    spec.summary        = "Redux-Observable libarary."
    spec.description    = "This is a Swift implementation of Redux-Observable architecture, based on RxSwift library."
    
    spec.homepage       = "https://github.com/grability-inc/ReduxObservableSwift"
    spec.license        = { :type => "MIT", :file => "LICENSE.md" }
    spec.author         = { "cjortegon" => "mountainreacher@gmail.com" }
    spec.source         = { :git => "https://github.com/grability-inc/ReduxObservableSwift.git", :tag => "#{spec.version}" }

    # Platform Specifics
    spec.platform       = :ios, "8.0"

    # Source Code
    spec.source_files   = "ReduxObservable/*.swift"

    spec.swift_version  = '4.2'

end