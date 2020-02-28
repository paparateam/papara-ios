Pod::Spec.new do |s|
  s.name = 'Papara'
  s.version = '5.2.0'
  s.license = 'MIT'
  s.summary = 'Papara SDK'
  s.homepage = 'https://github.com/paparateam/papara-ios'
  s.authors = { 'Papara' => 'info@papara.com' }
  s.source = { :git => 'https://github.com/paparateam/papara-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'

  s.source_files = 'Sources/*.swift'

  s.resource_bundles = {
    'Papara' => ['Assets/{*}', 'Sources/*.storyboard']
  }
end
