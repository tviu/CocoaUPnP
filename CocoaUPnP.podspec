Pod::Spec.new do |s|

  s.name         = "CocoaUPnP"
  s.version      = "0.1.3"
  s.summary      = "A modern and well tested UPnP library which feature asynchronous network calls."

  s.description  = <<-DESC
                   CocoaUPnP is a logical progression of [upnpx](https://github.com/fkuehne/upnpx) 
                   - designed to be easy, modern and block-based.

                   Currently it supports most of the methods required by the audio video device
                   control protocols.

                   It features a comprehensive suite of unit tests
                   DESC

  s.homepage     = "https://github.com/arcam/CocoaUPnP"
  s.license      = "MIT"
  s.author       = { "Paul Williamson" => "PaulW@arcam.co.uk" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/arcam/CocoaUPnP.git", :tag => s.version.to_s }
  s.source_files = "CocoaUPnP", "CocoaUPnP/**/*.{h,m}"
  s.requires_arc = true
  s.xcconfig     = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'CocoaAsyncSocket', '~> 7.4'
  s.dependency 'Ono', '~> 1.2'
  s.dependency 'AFNetworking', '~> 2.6'
  s.dependency 'GCDWebServer', '~> 3.2'
end
