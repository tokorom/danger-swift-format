build:
	swift build

test:
	swift test 2>&1 | xcpretty

sample: build
	swiftc --driver-mode=swift -I .build/debug/ -L .build/debug/ -lDangerSwiftFormatDlib Sample.swift
