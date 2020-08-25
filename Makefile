build:
	swift build

test:
	swift test 2>&1 | xcpretty
