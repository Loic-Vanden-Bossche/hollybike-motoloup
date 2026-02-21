/*
  Hollybike API Kotlin KTor Graalvm application
  Made by MacaronFR (Denis TURBIEZ) and Loïc Vanden Bossche
*/
package hollybike.api.utils.search

import org.jetbrains.exposed.v1.jdbc.*
import hollybike.api.database.lower
import hollybike.api.database.unaccent
import io.ktor.http.*
import kotlin.time.Instant
import kotlinx.datetime.LocalDate
import kotlinx.datetime.TimeZone
import kotlinx.datetime.atStartOfDayIn
import org.jetbrains.exposed.v1.core.*
import org.jetbrains.exposed.v1.core.eq
import org.jetbrains.exposed.v1.core.greater
import org.jetbrains.exposed.v1.core.greaterEq
import org.jetbrains.exposed.v1.core.isNotNull
import org.jetbrains.exposed.v1.core.isNull
import org.jetbrains.exposed.v1.core.less
import org.jetbrains.exposed.v1.core.lessEq
import org.jetbrains.exposed.v1.core.like
import org.jetbrains.exposed.v1.core.neq
import org.jetbrains.exposed.v1.core.dao.id.EntityID
import org.jetbrains.exposed.v1.core.dao.id.IdTable
import org.jetbrains.exposed.v1.datetime.KotlinInstantColumnType

fun Parameters.getSearchParam(mapper: Mapper): SearchParam {
	val page = get("page")?.toIntOrNull() ?: 0
	val perPage = get("per_page")?.toIntOrNull() ?: 20
	val query = get("query")
	val sort = getAll("sort")?.mapNotNull {
		val (col, sort) = it.split(".")
		if (col in mapper.keys) {
			if (sort.uppercase() == "ASC") {
				Sort(mapper[col]!!, SortOrder.ASC)
			} else if (sort.uppercase() == "DESC") {
				Sort(mapper[col]!!, SortOrder.DESC)
			} else {
				null
			}
		} else {
			null
		}
	} ?: emptyList()
	val filter = mapper.asSequence().filter { (k, _) -> k in this }.flatMap { (k, v) ->
		getAll(k)!!.map allMap@{
			val (mode, value) = if (':' in it) {
				it.split(":", limit = 2).let { values -> values[0] to values[1] }
			} else {
				it to null
			}
			if (mode !in FilterMode) {
				null
			} else {
				val filterMode = FilterMode[mode]
				if (value == null && filterMode != FilterMode.IS_NULL && filterMode != FilterMode.IS_NOT_NULL) {
					null
				} else {
					Filter(v, value, FilterMode[mode])
				}
			}
		}
	}.filterNotNull().toMutableList()
	return SearchParam(
		query,
		sort,
		filter,
		page,
		perPage,
		mapper
	)
}

fun Query.applyParam(searchParam: SearchParam, pagination: Boolean = true): Query {
	var q = this
	q = q.orderBy(*searchParam.sort.map { (c, o) -> c to o }.toTypedArray())
	if (pagination) {
		q = q.limit(searchParam.perPage).offset(searchParam.page * searchParam.perPage.toLong())
	}
	val filter = searchParamFilter(searchParam.filter)
	val query = if ((searchParam.query?.split(" ")?.size ?: 0) == 2) {
		val values = searchParam.query!!.split(" ")
		val val1 = searchParamQuery(values.joinToString("%") { it.replace("%", "\\%") }, searchParam.mapper)
		val val2 = searchParamQuery(values.reversed().joinToString("%") { it.replace("%", "\\%") }, searchParam.mapper)
		if (val1 != null) {
			if (val2 != null) {
				val1 or val2
			} else {
				val1
			}
		} else {
			val2
		}
	} else {
		searchParam.query?.let { query -> searchParamQuery(
			query.replace("%", "\\%").replace(" ", "%"),
			searchParam.mapper
		) }
	}
	val where = if (query == null) {
		filter
	} else {
		if (filter == null) {
			query
		} else {
			query and filter
		}
	}
	return where?.let { q.where(where) } ?: q
}

@Suppress("UNCHECKED_CAST")
private fun searchParamQuery(query: String, mapper: Mapper): Op<Boolean>? {
	var op: Op<Boolean>? = null
	mapper.forEach { (_, col) ->
		when (col.columnType) {
			is IntegerColumnType -> {
				query.toIntOrNull()?.let {
					op = op?.or((col as Column<Int?>) eq it) ?: ((col as Column<Int?>) eq it)
				}
			}

			is VarCharColumnType -> {
				op =
					op?.or(lower(unaccent(col as Column<String>)) like lower(unaccent("%$query%"))) ?: (lower(
						unaccent((col as Column<String>))
					) like lower(unaccent("%$query%")))
			}
		}
	}
	return op
}

private fun searchParamFilter(filter: List<Filter>): Op<Boolean>? = filter
	.mapNotNull {
		when (it.mode) {
			FilterMode.EQUAL -> it.column equal it.value!!
			FilterMode.NOT_EQUAL -> it.column nEqual it.value!!
			FilterMode.LOWER_THAN -> it.column lt it.value!!
			FilterMode.GREATER_THAN -> it.column gt it.value!!
			FilterMode.LESS_THAN_EQUAL -> it.column lte it.value!!
			FilterMode.GREATER_THAN_EQUAL -> it.column gte it.value!!
			FilterMode.IS_NULL -> it.column.isNull()
			FilterMode.IS_NOT_NULL -> it.column.isNotNull()
		}
	}.reduceOrNull { acc, v ->
		acc and v
	}

private fun parseInstantValue(value: String): Instant? = try {
	Instant.parse(value)
} catch (_: IllegalArgumentException) {
	try {
		Instant.fromEpochMilliseconds(LocalDate.parse(value).atStartOfDayIn(TimeZone.UTC).toEpochMilliseconds())
	} catch (_: Exception) {
		null
	}
}

private enum class CompareOp {
	EQ,
	NEQ,
	LT,
	GT,
	LTE,
	GTE
}

private fun compareInt(column: Column<Int?>, value: Int, op: CompareOp): Op<Boolean> =
	when (op) {
		CompareOp.EQ -> column eq value
		CompareOp.NEQ -> column neq value
		CompareOp.LT -> column less value
		CompareOp.GT -> column greater value
		CompareOp.LTE -> column lessEq value
		CompareOp.GTE -> column greaterEq value
	}

private fun compareString(column: Column<String?>, value: String, op: CompareOp): Op<Boolean> =
	when (op) {
		CompareOp.EQ -> column eq value
		CompareOp.NEQ -> column neq value
		CompareOp.LT -> column less value
		CompareOp.GT -> column greater value
		CompareOp.LTE -> column lessEq value
		CompareOp.GTE -> column greaterEq value
	}

private fun compareInstant(column: Column<Instant?>, value: Instant, op: CompareOp): Op<Boolean> =
	when (op) {
		CompareOp.EQ -> column eq value
		CompareOp.NEQ -> column neq value
		CompareOp.LT -> column less value
		CompareOp.GT -> column greater value
		CompareOp.LTE -> column lessEq value
		CompareOp.GTE -> column greaterEq value
	}

@Suppress("UNCHECKED_CAST")
private fun Column<out Any?>.asIntEntityIdComparisonTarget(value: String): Pair<Column<EntityID<Int>>, EntityID<Int>>? {
	if (columnType !is EntityIDColumnType<*> || (columnType.sqlType() != "INT" && columnType.sqlType() != "SERIAL")) {
		return null
	}
	val entityIdType = columnType as? EntityIDColumnType<Int> ?: return null
	val id = value.toIntOrNull() ?: return null
	val table = entityIdType.idColumn.table as? IdTable<Int> ?: return null
	return (this as Column<EntityID<Int>>) to EntityID(id, table)
}

@Suppress("UNCHECKED_CAST")
private fun Column<out Any?>.asIntColumnComparisonTarget(value: String): Pair<Column<Int?>, Int>? {
	if (columnType !is EntityIDColumnType<*> || (columnType.sqlType() != "INT" && columnType.sqlType() != "SERIAL")) {
		return null
	}
	val intValue = value.toIntOrNull() ?: return null
	return (this as Column<Int?>) to intValue
}

@Suppress("UNCHECKED_CAST")
private fun Column<out Any?>.compareByType(value: String, op: CompareOp): Op<Boolean>? =
	when (columnType) {
		is IntegerColumnType -> value.toIntOrNull()?.let { compareInt(this as Column<Int?>, it, op) }
		is VarCharColumnType -> compareString(this as Column<String?>, value, op)
		is KotlinInstantColumnType -> parseInstantValue(value)?.let { compareInstant(this as Column<Instant?>, it, op) }
		is EntityIDColumnType<*> -> when (op) {
			CompareOp.EQ -> asIntEntityIdComparisonTarget(value)?.let { (col, entityId) -> col eq entityId }
			CompareOp.NEQ -> asIntEntityIdComparisonTarget(value)?.let { (col, entityId) -> col neq entityId }
			CompareOp.LT,
			CompareOp.GT,
			CompareOp.LTE,
			CompareOp.GTE -> asIntColumnComparisonTarget(value)?.let { (col, intValue) -> compareInt(col, intValue, op) }
		}
		else -> null
	}

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.equal(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.EQ)

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.nEqual(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.NEQ)

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.lt(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.LT)

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.gt(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.GT)

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.lte(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.LTE)

@Suppress("UNCHECKED_CAST")
private infix fun Column<out Any?>.gte(value: String): Op<Boolean>? =
	compareByType(value, CompareOp.GTE)

fun Mapper.getMapperData(): Map<String, String> = this.mapValues {
	when (it.value.columnType) {
		is VarCharColumnType -> "String"
		is IntegerColumnType -> "Int"
		is KotlinInstantColumnType -> "DateTime"
		is EntityIDColumnType<*> -> "Int (id)"
		else -> "Unknown"
	}
}



