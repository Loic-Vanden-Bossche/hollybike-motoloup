val ktorVersion: String by project
val kotlinVersion: String by project
val logbackVersion: String by project
val exposedVersion: String by project
val awsSdkKotlinVersion: String by project

plugins {
	application
	jacoco
	kotlin("jvm") version "2.3.10"
	id("com.github.ben-manes.versions") version "0.53.0"

	id("io.ktor.plugin") version "3.4.0"
	id("org.jetbrains.kotlin.plugin.serialization") version "2.3.10"
	id("org.graalvm.buildtools.native") version "0.11.4"
	id("com.google.devtools.ksp") version "2.3.5"
	id("org.liquibase.gradle") version "3.1.0"
}

group = "hollybike.api"

fun getNativeImageName(): String {
	if (hasProperty("image_name")) {
		return findProperty("image_name") as String
	}

	return "hollybike_server"
}

fun getIsOnPremiseMode(): Boolean {
	if (hasProperty("is_on_premise")) {
		return findProperty("is_on_premise") == "true"
	}

	return false
}

application {
	mainClass.set("hollybike.api.ApplicationKt")
}

repositories {
	mavenCentral()
}

sourceSets {
	main {
		kotlin {
			srcDir("${layout.buildDirectory.get()}/generated")
		}
	}
}

tasks.register("generateConstantsFile") {
	doLast {
		val outputDir = "${layout.buildDirectory.get()}/generated/src/constants"
		val outputFile = File(outputDir, "Constants.kt")

		outputFile.parentFile.mkdirs()
		outputFile.writeText("""
            package generated

            object Constants {
                const val IS_ON_PREMISE = ${getIsOnPremiseMode()}
            }
        """.trimIndent())
	}
}

tasks.getByName("compileKotlin").dependsOn("generateConstantsFile")

tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
	compilerOptions {
		allWarningsAsErrors.set(false)
	}
}

dependencies {
	implementation("io.ktor:ktor-server-core:$ktorVersion")
	implementation("io.ktor:ktor-server-cio:$ktorVersion")
	implementation("io.ktor:ktor-server-content-negotiation:$ktorVersion")
	implementation("io.ktor:ktor-serialization-kotlinx-json:$ktorVersion")
	implementation("ch.qos.logback:logback-classic:$logbackVersion")
	implementation("io.ktor:ktor-server-websockets:$ktorVersion")
	implementation("io.ktor:ktor-server-caching-headers:$ktorVersion")
	implementation("io.ktor:ktor-server-cors:$ktorVersion")
	implementation("io.ktor:ktor-server-auth:$ktorVersion")
	implementation("io.ktor:ktor-server-auth-jwt:$ktorVersion")
	implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.7.1-0.6.x-compat")
	implementation("io.ktor:ktor-server-metrics-micrometer-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-swagger-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-compression-jvm:$ktorVersion")
	implementation("io.ktor:ktor-server-resources:$ktorVersion")
	implementation("io.ktor:ktor-server-call-logging:$ktorVersion")
	implementation("io.ktor:ktor-server-html-builder:$ktorVersion")
	implementation("io.ktor:ktor-server-websockets:$ktorVersion")
//	implementation("io.ktor:ktor-serialization-kotlinx-xml:$ktorVersion")

	implementation("io.github.pdvrieze.xmlutil:core:0.91.3")
//	implementation("io.github.pdvrieze.xmlutil:core-jvm:0.90.1")
	implementation("io.github.pdvrieze.xmlutil:serialization-jvm:0.91.3")

	implementation("io.ktor:ktor-client-core:$ktorVersion")
	implementation("io.ktor:ktor-client-cio:$ktorVersion")
	implementation("io.ktor:ktor-client-logging:$ktorVersion")
	implementation("io.ktor:ktor-client-json:$ktorVersion")
	implementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
	implementation("io.ktor:ktor-client-serialization:$ktorVersion")

	implementation("de.nycode:bcrypt:2.3.0")
	implementation("io.micrometer:micrometer-registry-prometheus:1.16.3")
	implementation("org.jetbrains.exposed:exposed-core:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-jdbc:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-dao:$exposedVersion")
	implementation("org.jetbrains.exposed:exposed-kotlin-datetime:$exposedVersion")

	implementation("aws.sdk.kotlin:s3:$awsSdkKotlinVersion")

	implementation("com.squareup.okhttp3:okhttp:5.3.2")
	implementation("commons-net:commons-net:3.12.0")

	implementation("org.apache.commons:commons-imaging:1.0.0-alpha6")

	implementation("org.postgresql:postgresql:42.7.10")
	implementation("org.liquibase:liquibase-core:5.0.1")
	implementation("software.amazon.awssdk:cloudfront:2.41.29")
	implementation("org.simplejavamail:simple-java-mail:8.12.6")
	ksp(project(":processor"))

	liquibaseRuntime("org.liquibase:liquibase-core:5.0.1")
	liquibaseRuntime("info.picocli:picocli:4.7.7")
	liquibaseRuntime("org.yaml:snakeyaml:2.5")
	liquibaseRuntime("org.postgresql:postgresql:42.7.10")

	testImplementation("io.ktor:ktor-server-tests-jvm:2.3.13")
	testImplementation("org.jetbrains.kotlin:kotlin-test-junit:$kotlinVersion")
	testImplementation("io.ktor:ktor-server-test-host-jvm:3.4.0")
	testImplementation("org.testcontainers:junit-jupiter:1.21.4")
	testImplementation("org.junit.jupiter:junit-jupiter-api:6.0.2")
	testImplementation("io.ktor:ktor-client-content-negotiation:$ktorVersion")
	testImplementation("org.testcontainers:postgresql:1.21.4")
	testImplementation("io.kotest:kotest-runner-junit5-jvm:6.1.3")
	testImplementation("io.kotest:kotest-assertions-core:6.1.3")
}

liquibase {
	activities.register("main") {
		val dbUrl = System.getenv("DB_URL")
		val dbUser = System.getenv("DB_USER")
		val dbPass = System.getenv("DB_PASSWORD")
		val refDbUrl = System.getenv("REF_DB_URL")
		val refDbUser = System.getenv("REF_DB_USER")
		val refDbPass = System.getenv("REF_DB_PASSWORD")
		arguments =
			mapOf(
				"referenceUrl" to refDbUrl,
				"referenceUsername" to refDbUser,
				"referencePassword" to refDbPass,
				"logLevel" to "info",
				"changelogFile" to "src/main/resources/liquibase-changelog.sql",
				"url" to dbUrl,
				"username" to dbUser,
				"password" to dbPass,
			)
	}
	runList = "main"
}

tasks.withType<Test>().configureEach {
	useJUnitPlatform()
	systemProperty("java.util.logging.config.file", file("src/test/resources/logging.properties").absolutePath)
	testLogging {
		events("passed", "failed", "skipped")
	}
}

tasks.jacocoTestReport {
	dependsOn(tasks.test)
	reports {
		xml.required.set(true)
		html.required.set(true)
		csv.required.set(false)
	}
}

tasks.test {
	finalizedBy(tasks.jacocoTestReport)
}

tasks.register<JavaExec>("runNativeAgent") {
	group = "application"
	description = "Run the backend with GraalVM native-image agent enabled."
	dependsOn("classes")
	mainClass.set("hollybike.api.AgentMainKt")
	classpath = sourceSets["main"].runtimeClasspath
	val outputDir = (project.findProperty("nativeImageAgentOutputDir") as String?) ?: "native-image/run"
	doFirst {
		file(outputDir).mkdirs()
	}
	jvmArgs("-agentlib:native-image-agent=config-merge-dir=$outputDir,config-write-period-secs=10")
}

tasks.register<Test>("testNativeAgent") {
	group = "verification"
	description = "Run tests with GraalVM native-image agent and collect metadata."
	dependsOn("testClasses")
	testClassesDirs = sourceSets["test"].output.classesDirs
	classpath = sourceSets["test"].runtimeClasspath
	maxParallelForks = 1
	val outputDir = (project.findProperty("nativeImageAgentOutputDir") as String?) ?: "native-image/test"
	doFirst {
		file(outputDir).mkdirs()
	}
	jvmArgs("-agentlib:native-image-agent=config-merge-dir=$outputDir")
}

tasks.register("mergeNativeAgentConfigs") {
	group = "verification"
	description = "Merge all native-image agent outputs into a single configuration directory."
	doLast {
		val inputRoots = ((project.findProperty("nativeImageAgentInputDirs") as String?)
			?: "native-image/test,native-image/run")
			.split(",")
			.map { file(it.trim()) }
			.filter { it.path.isNotBlank() }
		val outputDir = file((project.findProperty("nativeImageAgentMergedDir") as String?) ?: "native-image/merged")
		outputDir.mkdirs()

		val existingRoots = inputRoots.filter { it.exists() }
		if (existingRoots.isEmpty()) {
			throw GradleException("No input directories found. Checked: ${inputRoots.joinToString { it.path }}")
		}
		existingRoots.forEach { root ->
			val lockFile = file("${root.path}/.lock")
			if (lockFile.exists()) {
				val pid = lockFile.readText().trim().toLongOrNull()
				val isRunning = pid?.let { ProcessHandle.of(it).isPresent } ?: false
				if (!isRunning) {
					lockFile.delete()
					println("Removed stale agent lock: ${lockFile.path}")
				}
			}
		}
		val unlockedRoots = existingRoots.filter { !file("${it.path}/.lock").exists() }
		if (unlockedRoots.isEmpty()) {
			throw GradleException("All input directories are locked by native-image-agent: ${existingRoots.joinToString { it.path }}")
		}
		existingRoots.filter { file("${it.path}/.lock").exists() }.forEach {
			println("Skipping locked agent directory: ${it.path}")
		}

		val inputDirs = mutableListOf<File>()
		unlockedRoots.forEach { inputRoot ->
			if (file("${inputRoot.path}/reflect-config.json").exists()) {
				inputDirs.add(inputRoot)
			}
			inputRoot.listFiles()
				?.filter { it.isDirectory && it.name.startsWith("agent-pid") && file("${it.path}/reflect-config.json").exists() }
				?.sortedBy { it.name }
				?.let { inputDirs.addAll(it) }
		}

		if (inputDirs.isEmpty()) {
			throw GradleException("No agent config directories found under: ${unlockedRoots.joinToString { it.path }}")
		}

		val isWindows = System.getProperty("os.name").lowercase().contains("windows")
		val exeName = if (isWindows) "native-image-configure.cmd" else "native-image-configure"
		fun candidateFromJavaHome(javaHome: String?): String? {
			if (javaHome.isNullOrBlank()) return null
			val candidate = file("$javaHome/bin/$exeName")
			return if (candidate.exists()) candidate.absolutePath else null
		}

		val explicitPath = (project.findProperty("nativeImageConfigurePath") as String?)?.takeIf { it.isNotBlank() }
		val resolvedNativeImageConfigure = explicitPath
			?: candidateFromJavaHome(System.getenv("JAVA_HOME"))
			?: candidateFromJavaHome(System.getProperty("java.home"))
			?: run {
				val userHome = System.getProperty("user.home")
				val jdksDir = file("$userHome/.jdks")
				if (jdksDir.exists()) {
					jdksDir.listFiles()
						?.filter { it.isDirectory && it.name.contains("graalvm", ignoreCase = true) }
						?.sortedByDescending { it.lastModified() }
						?.mapNotNull { candidateFromJavaHome(it.absolutePath) }
						?.firstOrNull()
				} else {
					null
				}
			}
			?: "native-image-configure"

		val argsFile = file("${layout.buildDirectory.get().asFile.path}/tmp/merge-native-agent-args.txt")
		argsFile.parentFile.mkdirs()
		argsFile.writeText(
			buildString {
				appendLine("generate")
				inputDirs.forEach { appendLine("--input-dir=${it.absolutePath}") }
				appendLine("--output-dir=${outputDir.absolutePath}")
			},
		)

		try {
			exec {
				commandLine(resolvedNativeImageConfigure, "command-file", argsFile.absolutePath)
			}
		} catch (e: Exception) {
			throw GradleException(
				"Unable to execute native-image-configure. " +
					"Set JAVA_HOME to GraalVM or pass -PnativeImageConfigurePath=\"C:/path/to/$exeName\"",
				e,
			)
		}

		val copyTargets = mapOf(
			"reflect-config.json" to file("processor/src/main/resources/reflect-config-sample.json"),
			"jni-config.json" to file("src/main/resources/jni-config.json"),
			"proxy-config.json" to file("src/main/resources/proxy-config.json"),
			"resource-config.json" to file("src/main/resources/resource-config.json"),
		)
		copyTargets.forEach { (sourceName, targetFile) ->
			val sourceFile = file("${outputDir.path}/$sourceName")
			if (!sourceFile.exists()) {
				throw GradleException("Merged config file not found: ${sourceFile.path}")
			}
			targetFile.parentFile.mkdirs()
			targetFile.writeText(sourceFile.readText())
			println("Updated ${targetFile.path} from ${sourceFile.path}")
		}

		println("Merged ${inputDirs.size} agent directories into ${outputDir.path}")
		println("Final reflect config: ${outputDir.path}/reflect-config.json")
	}
}

graalvmNative {
	agent {
		defaultMode.set("standard")
	}

	binaries {
		all {
			javaLauncher.set(
				javaToolchains.launcherFor {
					languageVersion.set(JavaLanguageVersion.of(21))
// 					vendor.set(JvmVendorSpec.ORACLE)
				},
			)
		}
		named("main") {
			fallback.set(false)
			verbose.set(true)

			buildArgs.add("-march=x86-64-v2")
			buildArgs.add("--initialize-at-run-time=liquibase.util.StringUtil")
			buildArgs.add("--initialize-at-run-time=liquibase.command.core")
			buildArgs.add("--initialize-at-run-time=liquibase.diff.compare.CompareControl")
			buildArgs.add("--initialize-at-run-time=liquibase.snapshot.SnapshotIdService")

			buildArgs.add("--initialize-at-run-time=liquibase.sqlgenerator.core.LockDatabaseChangeLogGenerator")

			buildArgs.add("--initialize-at-run-time=de.nycode.bcrypt.BCryptKt")

			buildArgs.add("--initialize-at-run-time=sun.font.SunFontManager")
			buildArgs.add("--initialize-at-run-time=sun.java2d.Disposer")
			buildArgs.add("--initialize-at-run-time=sun.font.StrikeCache")
			buildArgs.add("--initialize-at-run-time=sun.font.PhysicalStrike")

			buildArgs.add("--initialize-at-run-time=org.simplejavamail.internal.util.MiscUtil")
			buildArgs.add("--initialize-at-run-time=org.simplejavamail.internal.moduleloader.ModuleLoader")
			buildArgs.add("--initialize-at-build-time=kotlin.DeprecationLevel")

			buildArgs.add("--install-exit-handlers")
			buildArgs.add("--report-unsupported-elements-at-runtime")

			buildArgs.add("-H:+ReportExceptionStackTraces")
			buildArgs.add(
				"-H:ReflectionConfigurationFiles=${project.projectDir}/build/generated/ksp/main/resources/META-INF/native-image/reflect-config.json",
			)

			buildArgs.add("-H:JNIConfigurationFiles=${project.projectDir}/src/main/resources/jni-config.json")
			buildArgs.add("-H:ResourceConfigurationFiles=${project.projectDir}/src/main/resources/resource-config.json")
			buildArgs.add("-H:DynamicProxyConfigurationFiles=${project.projectDir}/src/main/resources/proxy-config.json")

			buildArgs.add("-H:+StaticExecutableWithDynamicLibC")

			buildArgs.add("--features=okhttp3.internal.graal.OkHttpFeature")

			resources.autodetect()

			imageName.set(getNativeImageName())
		}
	}

	metadataRepository {
		enabled.set(true)
	}
}


buildscript {
	dependencies {
		classpath("org.liquibase:liquibase-core:5.0.1")
	}
}


tasks.register("printVersion") {
	doLast {
		println(project.version)
	}
}




