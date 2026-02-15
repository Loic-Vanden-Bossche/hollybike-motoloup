/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
import com.google.devtools.ksp.KspExperimental
import com.google.devtools.ksp.processing.*
import com.google.devtools.ksp.symbol.KSAnnotated
import com.google.devtools.ksp.symbol.KSClassDeclaration
import com.google.devtools.ksp.symbol.KSDeclaration
import java.io.File
import java.util.*

class Processor(
	val codeGenerator: CodeGenerator,
	val logger: KSPLogger
) : SymbolProcessor {
	private val exposedIntEntityNames = setOf(
		"org.jetbrains.exposed.v1.dao.IntEntity",
		"org.jetbrains.exposed.dao.IntEntity",
	)

	override fun process(resolver: Resolver): List<KSAnnotated> {
		val sample = loadSampleConfig().trim().trim('[', ']')
		val ser = processSerializable(resolver)
		val ent = processEntity(resolver)
		val outStream = try {
			codeGenerator.createNewFileByPath(Dependencies(false, *resolver.getAllFiles().toList().toTypedArray()), "META-INF/native-image/reflect-config", "json")
		} catch (e: FileAlreadyExistsException) {
			logger.warn("Didn't create file")
			return ent.first + ser.first
		}
		val jsons = ser.second + ent.second
		val entries = mutableListOf<String>()
		if (sample.isNotBlank()) {
			entries.add(sample)
		}
		entries.addAll(jsons.filter { it.isNotBlank() })
		outStream.write("[${entries.joinToString(",\n")}]".toByteArray())
		return ent.first + ser.first
	}

	private fun loadSampleConfig(): String {
		val fileCandidates = listOf(
			"processor/src/main/resources/reflect-config-sample.json",
			"src/main/resources/reflect-config-sample.json",
		)
		fileCandidates.forEach { path ->
			val content = runCatching {
				val file = File(path)
				if (file.exists()) file.readText() else null
			}.onFailure {
				logger.warn("Unable to read sample file $path: ${it.message}")
			}.getOrNull()
			if (!content.isNullOrBlank()) {
				return content
			}
		}

		val resource = "/reflect-config-sample.json"
		return runCatching {
			this::class.java.getResource(resource)?.readText()
		}.onFailure {
			logger.warn("Unable to read $resource: ${it.message}")
		}.getOrNull().orEmpty()
	}

	private fun processSerializable(resolver: Resolver): Pair<List<KSAnnotated>, List<String>> {
		val symbols = resolver.getSymbolsWithAnnotation("kotlinx.serialization.Serializable", true).filter { it is KSClassDeclaration }
		val jsons = mutableListOf<String>()

		symbols.toList().forEach { s ->
			if (s !is KSClassDeclaration) {
				return@forEach
			}
			val parameterTypes = if (s.typeParameters.isNotEmpty()) {
				s.typeParameters.joinToString(",", "[", "]") { _ -> "\"kotlinx.serialization.KSerializer\"" }
			} else {
				"[]"
			}
			val json = """
					{"name": "${s.qualifiedName?.asString()}","fields": [{"name": "Companion"}]},
					{"name": "${s.qualifiedName?.asString()}${'$'}Companion","methods":[{"name":"serializer","parameterTypes":$parameterTypes }]}
				""".trimIndent()
			jsons.add(json)
		}
		return symbols.toList() to jsons
	}

	@OptIn(KspExperimental::class)
	private fun processEntity(resolver: Resolver): Pair<List<KSDeclaration>, List<String>> {
		val symbols = resolver.getDeclarationsFromPackage("hollybike.api.repository").filter { it is KSClassDeclaration }.toList()
		val jsons = mutableListOf<String>()
		val finalSymbols = mutableListOf<KSDeclaration>()
		symbols.forEach { d ->
			if(d !is KSClassDeclaration){
				return@forEach
			}
			var entity = false
			var ref = false
			d.superTypes.forEach { superType ->
				val parent = superType.resolve().declaration as? KSClassDeclaration
				if (parent?.qualifiedName?.asString() in exposedIntEntityNames) {
					entity = true
				}
			}
			val json = if(entity) {
				finalSymbols.add(d)
				val json = mutableListOf("\"name\":\"${d.qualifiedName?.asString()}\"")
				val methods = mutableListOf("{\"name\":\"<init>\",\"parameterTypes\":[\"org.jetbrains.exposed.v1.core.dao.id.EntityID\"]}")
				val fields = mutableListOf<String>()
				d.getAllProperties().forEach { prop ->
					val propDecl = prop.type.resolve().declaration
					if (
						propDecl is KSClassDeclaration &&
						propDecl.superTypes.any {
							(it.resolve().declaration as? KSClassDeclaration)?.qualifiedName?.asString() in exposedIntEntityNames
						}
					) {
						ref = true
						val capitalizedName = prop.simpleName.asString().replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
						methods.add("{\"name\":\"get$capitalizedName\",\"parameterTypes\":[] }, {\"name\":\"set$capitalizedName\",\"parameterTypes\":[\"${propDecl.qualifiedName?.asString()}\"] }")
						fields.add("{\"name\": \"${prop.simpleName.asString()}${'$'}delegate\"}")
					}
				}
				if(ref) {
					json.add("\"fields\":${fields.joinToString(",", prefix = "[", postfix = "]") }")
				}
				json.add("\"methods\": ${methods.joinToString(",", prefix = "[", postfix = "]")}")
				json.joinToString(",\n", prefix = "{", postfix = "}")
			} else {
				""
			}
			if(json.isNotEmpty()) {
				jsons.add(json)
			}
		}
		return finalSymbols to jsons
	}
}


class ProcessorProvider : SymbolProcessorProvider {
	override fun create(environment: SymbolProcessorEnvironment): SymbolProcessor {
		return Processor(environment.codeGenerator, environment.logger)
	}
}
