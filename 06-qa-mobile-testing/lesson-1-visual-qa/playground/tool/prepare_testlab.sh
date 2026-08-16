#!/bin/bash
# Prepares the generated Android project for Firebase Test Lab:
# integration_test on Test Lab runs as an Android "instrumentation
# test", which needs a tiny Java shim + androidx test runner deps.
# Run AFTER `flutter create . --platforms=android`, from the playground root.
set -euo pipefail

APP_GRADLE=""
for candidate in android/app/build.gradle.kts android/app/build.gradle; do
  [ -f "$candidate" ] && APP_GRADLE="$candidate" && break
done
[ -n "$APP_GRADLE" ] || { echo "No android/app gradle file — run flutter create first"; exit 1; }

PACKAGE=$(grep -oE 'applicationId\s*=?\s*"[^"]+"' "$APP_GRADLE" | grep -oE '"[^"]+"' | tr -d '"')
[ -n "$PACKAGE" ] || { echo "Could not detect applicationId"; exit 1; }
echo "Detected package: $PACKAGE"

TEST_DIR="android/app/src/androidTest/java/$(echo "$PACKAGE" | tr '.' '/')"
mkdir -p "$TEST_DIR"

cat > "$TEST_DIR/MainActivityTest.java" <<EOF
package $PACKAGE;

import androidx.test.rule.ActivityTestRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.Rule;
import org.junit.runner.RunWith;

@RunWith(FlutterTestRunner.class)
public class MainActivityTest {
  @Rule
  public ActivityTestRule<MainActivity> rule =
      new ActivityTestRule<>(MainActivity.class, true, false);
}
EOF
echo "Wrote $TEST_DIR/MainActivityTest.java"

if [[ "$APP_GRADLE" == *.kts ]]; then
  cat >> "$APP_GRADLE" <<'EOF'

android {
    defaultConfig {
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }
}

dependencies {
    androidTestImplementation("androidx.test:runner:1.6.2")
    androidTestImplementation("androidx.test:rules:1.6.1")
}
EOF
else
  cat >> "$APP_GRADLE" <<'EOF'

android {
    defaultConfig {
        testInstrumentationRunner "androidx.test.runner.AndroidJUnitRunner"
    }
}

dependencies {
    androidTestImplementation 'androidx.test:runner:1.6.2'
    androidTestImplementation 'androidx.test:rules:1.6.1'
}
EOF
fi
echo "Patched $APP_GRADLE for instrumentation testing"
