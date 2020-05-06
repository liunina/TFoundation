Pod::Spec.new do |s|
  s.name             = 'TFoundation'
  s.version          = '0.1.12'
  s.summary          = '工具库.包含所有工具(网络,缓存,偏好设置,类目)组件'

  s.description      = <<-DESC
该项目仅供T11项目使用,项目包含APP中使用的底层工具函数
                       DESC

  s.homepage         = 'http://nas.iliunian.com:82/apple/TFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuNian' => 'i19850511@gmail.com' }
  s.source           = { :git => 'http://nas.iliunian.com:82/apple/TFoundation.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  
  s.requires_arc = true
  
  s.subspec 'Internal' do |ss|
	  ss.public_header_files = 'TFoundation/Internal/*.h'
	  ss.source_files = 'TFoundation/Internal/**/*'
  end
  
  s.subspec 'Logger' do |ss|
	  ss.dependency 'CocoaLumberjack'
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Logger/*.h'
	  ss.source_files = 'TFoundation/Logger/**/*'
  end
  s.subspec 'Cache' do |ss|
	  ss.dependency 'DFCache'
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Cache/*.h'
	  ss.source_files = 'TFoundation/Cache/**/*'
  end

  s.subspec 'Preferences' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.dependency 'TFoundation/Cache'
	  ss.public_header_files = 'TFoundation/Preferences/*.h'
	  ss.source_files = 'TFoundation/Preferences/**/*'
  end
  
#  s.subspec 'NetWork' do |ss|
#	  ss.dependency 'TFoundation/Internal'
#	  ss.dependency 'AFNetworking'
#	  ss.public_header_files = 'TFoundation/NetWork/*.h'
#	  ss.source_files = 'TFoundation/NetWork/**/*'
#  end
  
  s.subspec 'Category' do |ss|
	   ss.dependency 'GTMBase64'
	   ss.dependency 'JSONModel'
	   ss.dependency 'TFoundation/Internal'
	   ss.dependency 'TFoundation/DataSafe'
	   ss.public_header_files = 'TFoundation/Category/*.h'
	   ss.source_files = 'TFoundation/Category/**/*'
  end
  s.subspec 'Hard' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Hard/*.h'
	  ss.source_files = 'TFoundation/Hard/**/*'
  end
  
  s.subspec 'DataSafe' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.dependency 'TFoundation/Hard'
	  ss.public_header_files = 'TFoundation/DataSafe/*.h'
	  ss.source_files = 'TFoundation/DataSafe/**/*'
  end
  
  s.subspec 'ArchiveData' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.dependency 'TFoundation/FileManager'
	  ss.public_header_files = 'TFoundation/ArchiveData/*.h'
	  ss.source_files = 'TFoundation/ArchiveData/**/*'
  end
  
  s.subspec 'FileManager' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/FileManager/*.h'
	  ss.source_files = 'TFoundation/FileManager/**/*'
  end
  
  s.subspec 'Predicate' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Predicate/*.h'
	  ss.source_files = 'TFoundation/Predicate/**/*'
  end
  s.subspec 'Timer' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Timer/*.h'
	  ss.source_files = 'TFoundation/Timer/**/*'
  end
  s.subspec 'UserDefault' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/UserDefault/*.h'
	  ss.source_files = 'TFoundation/UserDefault/**/*'
  end
  
  s.subspec 'Keychain' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Keychain/*.h'
	  ss.source_files = 'TFoundation/Keychain/**/*'
  end
  
  s.subspec 'Device' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.dependency 'TFoundation/Keychain'
	  ss.dependency 'TFoundation/Category'
	  ss.public_header_files = 'TFoundation/Device/*.h'
	  ss.source_files = 'TFoundation/Device/**/*'
  end
  
  s.subspec 'Media' do |ss|
	  ss.dependency 'TFoundation/Internal'
	  ss.public_header_files = 'TFoundation/Media/*.h'
	  ss.source_files = 'TFoundation/Media/**/*'
	  ss.frameworks = 'AudioToolBox'
  end
  
  s.subspec 'Dealloc' do |ss|
	  ss.dependency 'TFoundation/Category'
	  ss.public_header_files = 'TFoundation/Dealloc/*.h'
	  ss.source_files = 'TFoundation/Dealloc/**/*'
  end
  
  
  s.frameworks = "Foundation", "MobileCoreServices", "CoreServices"
  s.xcconfig = {"OHTER_LINKER_FLAGS" => "-OjbC"}
  s.user_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }
end
