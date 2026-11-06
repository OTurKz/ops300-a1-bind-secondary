
pipeline {
    agent {
        label 'podman-agent'
    }

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
    }

    triggers {
        pollSCM('H/5 * * * *')
    }

    environment {
        REGISTRY = 'registry.assign.oturkmani.300.ops:5000'
        IMAGE_REPO = 'registry.assign.oturkmani.300.ops:5000/ops300/bind-secondary'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                sh '''
                    set -eu
                    SHORT_SHA="$(git rev-parse --short=12 HEAD)"
                    IMAGE_TAG="${BUILD_NUMBER}-${SHORT_SHA}"

                    podman build \
                        --file Dockerfile \
                        --tag "${IMAGE_REPO}:${IMAGE_TAG}" \
                        .
                '''
            }
        }

        stage('Push image') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'ops300-a1-registry-login',
                        usernameVariable: 'REGISTRY_USER',
                        passwordVariable: 'REGISTRY_PASSWORD'
                    )
                ]) {
                    sh '''
                        set -eu
                        set +x

                        SHORT_SHA="$(git rev-parse --short=12 HEAD)"
                        IMAGE_TAG="${BUILD_NUMBER}-${SHORT_SHA}"

                        printf '%s' "$REGISTRY_PASSWORD" |
                            podman login "$REGISTRY" \
                                --username "$REGISTRY_USER" \
                                --password-stdin

                        podman push "${IMAGE_REPO}:${IMAGE_TAG}"

                        podman logout "$REGISTRY"
                    '''
                }
            }
        }
    }
}
