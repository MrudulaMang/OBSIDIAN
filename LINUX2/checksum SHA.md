echo "$(cat kubectl.sha256) kubectl" | sha256sum --check
	-gets sha256 from kubectlsha and passes this and kubectl file to sha256sum, here it verifies the sha value againt the kubectl file sha and gives output as ok if it is same
	