allprojects {
    repositories {
        google()
        mavenCentral()

		allprojects {
			repositories {
				google()
				mavenCentral()

				maven {
					url = uri("https://api.mapbox.com/downloads/v2/releases/maven")
					credentials(PasswordCredentials::class) {
						username = "mapbox"
						password = providers
							.gradleProperty("MAPBOX_DOWNLOADS_TOKEN")
							.orElse(providers.environmentVariable("MAPBOX_DOWNLOADS_TOKEN"))
							.get()
					}
				}
			}
		}
    }
}


subprojects {
    afterEvaluate {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.let { androidExt ->
            if (androidExt.namespace == null) {
                androidExt.namespace = "com.example.${project.name}"
            }
        }
    }

	configurations.configureEach {
		resolutionStrategy.dependencySubstitution {
			// Maps SDK
			substitute(module("com.mapbox.maps:android"))
				.using(module("com.mapbox.maps:android-ndk27:11.16.0"))
			substitute(module("com.mapbox.maps:common"))
				.using(module("com.mapbox.maps:common-ndk27:11.16.0"))
		}
	}
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
