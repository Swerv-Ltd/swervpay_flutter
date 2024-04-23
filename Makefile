publish:
	@echo "Publishing to pub.dev"
	make dry-run
	@dart pub publish
	@echo "Published to pub.dev"

dry-run:
	@echo "Running dry-run..."
	@dart pub publish --dry-run