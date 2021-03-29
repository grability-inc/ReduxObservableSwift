Pod::Spec.new do |s|
    s.name           = "ReduxObservable"
    s.version        = "1.0.9"
    s.summary        = "Redux-Observable libarary."
    s.description    = "This is a Swift implementation of Redux-Observable architecture, based on RxSwift library."
    
    s.homepage       = "https://github.com/grability-inc/ReduxObservableSwift"
    s.license        = { :type => "MIT", :file => "LICENSE.md" }
    s.author         = { "cjortegon" => "mountainreacher@gmail.com" }
    s.source         = { :git => "https://github.com/grability-inc/ReduxObservableSwift.git", :tag => "#{s.version}" }

    # Platform Specifics
    s.platform       = :ios, "13.0"

    # Source Code
    s.source_files   = "ReduxObservable/*.swift"

    # Dependencies
    s.dependency 'RxSwift', '~> 6.1.0'

    s.swift_version  = '5.0'

end
