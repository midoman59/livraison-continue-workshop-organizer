#!/bin/bash

#
# Unified Test Execution Script
# Executes tests for both Angular frontend and Spring Boot backend
# Generates JUnit XML reports for CI/CD integration
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script configuration
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FRONTEND_DIR="${PROJECT_ROOT}/G-rez-l-int-gration-et-la-livraison-continue-Application-Angular"
BACKEND_DIR="${PROJECT_ROOT}/G-rez-l-int-gration-et-la-livraison-continue-Application-Java"
TEST_RESULTS_DIR="${PROJECT_ROOT}/test-results"

# Counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

#
# Logging functions
#
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

#
# Initialize test environment
#
init_environment() {
    log_info "Initializing test environment"

    # Clean previous test results
    if [ -d "${TEST_RESULTS_DIR}" ]; then
        log_info "Cleaning previous test results"
        rm -rf "${TEST_RESULTS_DIR}"
    fi

    # Create test results directory
    mkdir -p "${TEST_RESULTS_DIR}"
    log_success "Test results directory created: ${TEST_RESULTS_DIR}"
}

#
# Test Angular Frontend
#
test_frontend() {
    log_info ""
    log_info "════════════════════════════════════════"
    log_info "🧪 Testing Angular Frontend"
    log_info "════════════════════════════════════════"

    if [ ! -d "${FRONTEND_DIR}" ]; then
        log_warning "Frontend directory not found: ${FRONTEND_DIR}"
        return 1
    fi

    if [ ! -f "${FRONTEND_DIR}/package.json" ]; then
        log_warning "Frontend package.json not found"
        return 1
    fi

    log_info "Frontend directory: ${FRONTEND_DIR}"

    cd "${FRONTEND_DIR}"

    # Install dependencies
    log_info "Installing frontend dependencies"
    npm ci 2>&1 | tail -5

    # Run tests with coverage and JUnit reporter
    log_info "Running frontend tests"
    npm test -- --watch=false --browsers=ChromeHeadless --code-coverage 2>&1 || {
        log_error "Frontend tests failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    }

    # Copy JUnit reports
    log_info "Copying frontend test reports"
    if [ -d "${FRONTEND_DIR}/reports" ]; then
        cp -v "${FRONTEND_DIR}/reports"/*.xml "${TEST_RESULTS_DIR}/" 2>/dev/null || {
            log_warning "No JUnit XML reports found in ${FRONTEND_DIR}/reports"
        }
    elif [ -d "${FRONTEND_DIR}/coverage/junit" ]; then
        cp -v "${FRONTEND_DIR}/coverage/junit"/*.xml "${TEST_RESULTS_DIR}/" 2>/dev/null || {
            log_warning "No JUnit XML reports found in ${FRONTEND_DIR}/coverage/junit"
        }
    else
        log_warning "Frontend JUnit reports directory not found"
    fi

    log_success "Frontend tests completed"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

#
# Test Spring Boot Backend
#
test_backend() {
    log_info ""
    log_info "════════════════════════════════════════"
    log_info "🧪 Testing Spring Boot Backend"
    log_info "════════════════════════════════════════"

    if [ ! -d "${BACKEND_DIR}" ]; then
        log_warning "Backend directory not found: ${BACKEND_DIR}"
        return 1
    fi

    if [ ! -f "${BACKEND_DIR}/build.gradle" ]; then
        log_warning "Backend build.gradle not found"
        return 1
    fi

    log_info "Backend directory: ${BACKEND_DIR}"

    cd "${BACKEND_DIR}"

    # Run tests with Gradle
    log_info "Running backend tests"
    ./gradlew clean test -q 2>&1 || {
        log_error "Backend tests failed"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        return 1
    }

    # Copy JUnit reports
    log_info "Copying backend test reports"
    if [ -d "${BACKEND_DIR}/build/test-results/test" ]; then
        cp -v "${BACKEND_DIR}/build/test-results/test"/*.xml "${TEST_RESULTS_DIR}/" 2>/dev/null || {
            log_warning "No JUnit XML reports found in ${BACKEND_DIR}/build/test-results/test"
        }
    else
        log_warning "Backend JUnit reports directory not found"
    fi

    log_success "Backend tests completed"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

#
# Generate summary report
#
generate_summary() {
    log_info ""
    log_info "════════════════════════════════════════"
    log_info "📊 Test Execution Summary"
    log_info "════════════════════════════════════════"

    TESTS_TOTAL=$((TESTS_PASSED + TESTS_FAILED))

    log_info "Projects tested: ${TESTS_TOTAL}"
    log_success "Passed: ${TESTS_PASSED}"

    if [ ${TESTS_FAILED} -gt 0 ]; then
        log_error "Failed: ${TESTS_FAILED}"
    fi

    log_info "Test results directory: ${TEST_RESULTS_DIR}"

    # Count XML reports
    REPORT_COUNT=$(find "${TEST_RESULTS_DIR}" -name "*.xml" -type f | wc -l)
    log_info "JUnit reports generated: ${REPORT_COUNT}"

    if [ -n "$(ls -A ${TEST_RESULTS_DIR})" ]; then
        log_info "Reports:"
        ls -lah "${TEST_RESULTS_DIR}"/*.xml 2>/dev/null || true
    fi
}

#
# Main execution
#
main() {
    log_info "🚀 Starting unified test execution"
    log_info "Project root: ${PROJECT_ROOT}"

    # Initialize
    init_environment

    # Test projects
    test_frontend || true
    test_backend || true

    # Generate summary
    generate_summary

    # Exit with appropriate code
    if [ ${TESTS_FAILED} -gt 0 ]; then
        log_error "Test execution completed with failures exit 1"
        exit 1
    else
        log_success "All test suites completed successfully exit 0"
        exit 0
    fi
}

# Execute main function
main "$@"
