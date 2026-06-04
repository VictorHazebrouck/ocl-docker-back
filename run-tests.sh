chmod +x ./gradlew

if ! ./gradlew clean test; then
    ehco "'./gradlew clean test' failed"
    exit 1
fi

rm -rf test-results
mkdir -p test-results

REPORT_DIR="build/test-results/test"

if [ ! -d "$REPORT_DIR" ]; then
    echo "Error: JUnit report directory not found."
    exit 1
fi

cp -R "$REPORT_DIR"/* test-results/
