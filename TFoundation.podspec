Pod::Spec.new do |s|
  s.name             = 'TFoundation'
  s.version          = '0.1.0'
  s.summary          = '工具库.包含所有工具(网络,缓存,偏好设置),类目等组件'

  s.description      = <<-DESC
该项目仅供T11项目使用,项目包含APP中使用的素有底层工具函数
                       DESC

  s.homepage         = 'http://10.128.62.31/t11_app/TFoundation'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuNian' => 'i19850511@gmail.com' }
  s.source           = { :git => 'git@10.128.62.31:t11_app/tfoundation.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.requires_arc = true
  
  s.subspec 'Cache' do |cache|
	  cache.dependency 'DFCache'
	  cache.public_header_files = 'TFoundation/Cache/*.h'
	  cache.source_files = 'TFoundation/Cache/**/*'
  end

  s.subspec 'Preferences' do |pres|
	  pres.dependency 'TFoundation/Cache'
	  pres.public_header_files = 'TFoundation/Preferences/*.h'
	  pres.source_files = 'TFoundation/Preferences/**/*'
  end
  
  s.subspec 'NetWork' do |nw|
	  nw.dependency 'AFNetworking'
	  nw.public_header_files = 'TFoundation/NetWork/*.h'
	  nw.source_files = 'TFoundation/NetWork/**/*'
  end
  
  s.subspec 'Category' do |cg|
	   cg.dependency 'GTMBase64'
	   cg.public_header_files = 'TFoundation/Category/*.h'
	   cg.source_files = 'TFoundation/Category/**/*'
   end
end
