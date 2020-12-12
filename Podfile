def shared_pods
	pod 'Alamofire', '~> 4.8.2'
	pod 'SwiftyGif'
end

target 'Assignment' do

	use_frameworks!
	shared_pods

	target 'AssignmentTests' do
		inherit! :search_paths
	end

	target 'AssignmentUITests' do
		pod 'TABTestKit', '1.5.0'
		shared_pods
		inherit! :search_paths
	end

end

