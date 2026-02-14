plugins {
	kotlin("jvm")
}

group = "hollybike.api"
version = "unspecified"

repositories {
	mavenCentral()
}

dependencies {
	implementation("com.google.devtools.ksp:symbol-processing-api:2.3.5")
}

tasks.test {
	useJUnitPlatform()
}
kotlin {
    jvmToolchain(21)
}
tasks.named<Jar>("jar") {
    archiveFileName.set("processor-ksp.jar")
    destinationDirectory.set(layout.buildDirectory.dir("ksp-libs"))
}
