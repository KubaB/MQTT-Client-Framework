Pod::Spec.new do |mqttc|
	mqttc.name         = "MQTTClient"
	mqttc.version      = "0.15.3"
	mqttc.summary      = "iOS, macOS and tvOS native ObjectiveC MQTT Client Framework"
	mqttc.homepage     = "https://github.com/novastone-media/MQTT-Client-Framework"
	mqttc.license      = { :type => "EPLv1", :file => "LICENSE" }
	mqttc.author       = { "novastonemedia" => "ios@novastonemedia.com" }
	mqttc.source       = {
		:git => "https://github.com/bolteu/MQTT-Client-Framework.git",
		:commit => "e0b8c83e68c0c91bd2d07a611107381ac277ce7f"
	}

	mqttc.requires_arc = true
	mqttc.platform = :ios, "12.0", :osx, "10.10", :tvos, "9.0"
	mqttc.ios.deployment_target = "12.0"
	mqttc.osx.deployment_target = "10.10"
	mqttc.tvos.deployment_target = "9.0"
	mqttc.default_subspec = 'Core'

	source_root = "MQTTClient/MQTTClient"
	headers_root = "#{source_root}/include"
	min_files = %w[
		MQTTCFSocketDecoder
		MQTTCFSocketEncoder
		MQTTCFSocketTransport
		MQTTCoreDataPersistence
		MQTTDecoder
		MQTTInMemoryPersistence
		MQTTLog
		MQTTStrict
		MQTTClient
		MQTTMessage
		MQTTSSLSecurityPolicy
		MQTTSSLSecurityPolicyDecoder
		MQTTSSLSecurityPolicyEncoder
		MQTTSSLSecurityPolicyTransport
		MQTTProperties
		MQTTSession
		MQTTSessionLegacy
		MQTTSessionSynchron
		MQTTTransport
		GCDTimer
	]
	min_sources = min_files.map { |name| "#{source_root}/#{name}.m" }
	min_headers = min_files.map { |name| "#{headers_root}/#{name}.h" } + ["#{headers_root}/MQTTPersistence.h"]
	manager_files = %w[MQTTSessionManager ReconnectTimer ForegroundReconnection]
	manager_sources = manager_files.map { |name| "#{source_root}/#{name}.m" }
	manager_headers = manager_files.map { |name| "#{headers_root}/#{name}.h" }

	mqttc.subspec 'Core' do |core|
		core.dependency 'MQTTClient/Min'
		core.dependency 'MQTTClient/Manager'
	end

	mqttc.subspec 'Min' do |min|
		min.source_files = min_sources + min_headers
		min.public_header_files = min_headers
		min.header_mappings_dir = headers_root
	end

	mqttc.subspec 'MinL' do |minl|
		minl.dependency 'CocoaLumberjack'

		minl.source_files = min_sources + min_headers
		minl.public_header_files = min_headers
		minl.header_mappings_dir = headers_root
		minl.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LUMBERJACK=1' }
	end

	mqttc.subspec 'Manager' do |manager|
		manager.source_files = manager_sources + manager_headers
		manager.public_header_files = manager_headers
		manager.header_mappings_dir = headers_root
		manager.dependency 'MQTTClient/Min'
	end

	mqttc.subspec 'ManagerL' do |managerl|
		managerl.source_files = manager_sources + manager_headers
		managerl.public_header_files = manager_headers
		managerl.header_mappings_dir = headers_root
		managerl.dependency 'MQTTClient/MinL'
		managerl.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LUMBERJACK=1' }
	end

	mqttc.subspec 'Websocket' do |ws|
		ws.source_files = "#{source_root}/MQTTWebsocketTransport/*.m", "#{headers_root}/MQTTWebsocketTransport.h"
		ws.public_header_files = "#{headers_root}/MQTTWebsocketTransport.h"
		ws.header_mappings_dir = headers_root
		ws.dependency 'SocketRocket', '~> 0.6.0'
		ws.dependency 'MQTTClient/Min'
		ws.requires_arc = true
		ws.libraries = "icucore"
	end

	mqttc.subspec 'WebsocketL' do |wsl|
		wsl.source_files = "#{source_root}/MQTTWebsocketTransport/*.m", "#{headers_root}/MQTTWebsocketTransport.h"
		wsl.public_header_files = "#{headers_root}/MQTTWebsocketTransport.h"
		wsl.header_mappings_dir = headers_root
		wsl.dependency 'SocketRocket', '~> 0.6.0'
		wsl.dependency 'MQTTClient/MinL'
		wsl.requires_arc = true
		wsl.libraries = "icucore"
		wsl.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'LUMBERJACK=1' }
	end
end
