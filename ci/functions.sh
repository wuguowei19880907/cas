#!/bin/bash

installJdk11() {
    echo -e "Installing Java...\n"
    jdkVersion="11.0.6"
    jdkRevision="10"
    jdkDownloadUrl="https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download"
    url="${jdkDownloadUrl}/jdk-${jdkVersion}%2B${jdkRevision}/OpenJDK11U-jdk_x64_linux_${jdkVersion}_${jdkRevision}.tar.gz"
    wget https://github.com/sormuras/bach/raw/master/install-jdk.sh && chmod +x install-jdk.sh
    for i in {1..5}; do
        export JAVA_HOME=$(./install-jdk.sh --emit-java-home --url ${url} -c | tail --lines 1)
        if [[ -d ${JAVA_HOME} ]] ; then
            break;
        fi
        echo -e "Trying download again... [${i}]\n"
        sleep 5
    done
    echo JAVA_HOME=${JAVA_HOME}
}

currentChangeSetContains() {
    # Turn on for case-insensitive matching
    # shopt -s nocasematch

    if [[ "${TRAVIS_COMMIT_MESSAGE}" =~ "[force build]" || "${TRAVIS_COMMIT_MESSAGE}" =~ "Merge branch"  ]]; then
        echo "Build is forced. Commit message: ${TRAVIS_COMMIT_MESSAGE}"
        return 0
    fi

    results=`git diff --name-only HEAD~1`
    contains=false

    for i in "$results"
        do
            echo "Processing changed file: $i"
            if [[ ("$i" =~ $1) ]]; then
                echo "Found a match against pattern $1. Commit message: ${TRAVIS_COMMIT_MESSAGE}"
                return 0
            fi
    done
    return 1
}

currentChangeSetAffectsBuild() {
    currentChangeSetContains "\.(gradle|java|groovy|properties)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsTests() {
    currentChangeSetContains "\.(sh|java|groovy|xml|properties|yml|json)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsStyle() {
    currentChangeSetContains "\.(java|groovy|xml)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsJavadocs() {
    currentChangeSetContains "\.(java|groovy)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsDocumentation() {
    currentChangeSetContains "\.(md|properties|java)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsDependencies() {
    currentChangeSetContains "\.(gradle|properties|java|yml)"
    return `(expr "$?" + 0)`
}

currentChangeSetAffectsSnapshots() {
    currentChangeSetContains "\.(java|groovy|yml|gradle|properties|xml|json)"
    return `(expr "$?" + 0)`
}
