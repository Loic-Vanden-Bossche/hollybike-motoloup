/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Head, Sort,
} from "./Head.tsx";
import { useApi } from "../../utils/useApi.ts";
import {
	useCallback,
	useEffect, useMemo, useState,
} from "preact/hooks";
import { Search as SearchIcon } from "lucide-preact";
import { Input } from "../Input/Input.tsx";
import {
	ComponentChildren, JSX,
} from "preact";
import { TList } from "../../types/TList.ts";
import { Reload } from "../../utils/useReload.ts";
import { clsx } from "clsx";

interface ListProps<T> {
	columns: (Columns | null)[],
	baseUrl: string,
	line: (data: T) => ComponentChildren[]
	perPage?: number,
	reload?: Reload,
	filter?: string,
	action?: ComponentChildren,
	if?: boolean
}

export function List<T>(props: ListProps<T>) {
	const sortFilterColumns = useApi<TMetaData>(`${props.baseUrl}/meta-data`, [props.baseUrl], { if: props.if });
	const [sort, setSort] = useState<{ [name: string]: Sort }>({});
	const [search, setSearch] = useState("");
	const [page, setPage] = useState(0);

	useEffect(() => {
		const sortMap: { [name: string]: Sort } = {};
		Object.keys(sortFilterColumns.data ?? []).forEach((c) => {
			sortMap[c] = {
				column: c,
				order: "none",
			};
		});
		setSort(sortMap);
	}, [sortFilterColumns, setSort]);

	const setOrder = useCallback((col: string) => {
		if (sort[col] !== undefined) {
			return (order: "asc" | "desc" | "none") => {
				const tmp = { ...sort[col] };
				tmp.order = order;
				const res = { ...sort };
				res[col] = tmp;
				setSort(res);
			};
		}

		return undefined;
	}, [sort, setSort]);

	const orderQuery = useMemo(() => {
		const sortStrings = Object.values(sort)
			.filter(s => s.order !== "none")
			.map(s => `sort=${s.column}.${s.order}`);
		if (sortStrings.length > 0) {
			return `&${sortStrings.join("&")}`;
		} else {
			return "";
		}
	}, [sort]);

	const filterQuery = useMemo(() => {
		if (props.filter !== undefined && props.filter.length !== 0) {
			return `&${props.filter}`;
		} else {
			return "";
		}
	}, [props.filter]);

	const data = useApi<TList<T>>(
		`${props.baseUrl}?page=${page}&per_page=${props.perPage ?? 10}&query=${search}${orderQuery}${filterQuery}`,
		[
			props.baseUrl,
			props.perPage,
			page,
			search,
			orderQuery,
			props.reload,
		],
		{ if: props.if },
	);

	const onPageChange = useCallback((e: JSX.TargetedEvent<HTMLInputElement>) => {
		const p = parseInt(e.currentTarget.value);
		if (!isNaN(p) && p > 0 && p <= (data.data?.total_page ?? 1)) {
			setPage(parseInt(e.currentTarget.value) - 1);
		}
	}, [setPage, data.data?.total_page]);

	return (
		<div className={"flex flex-col grow gap-6"}>
			{ /* Toolbar */ }
			<div className={"flex justify-between items-center"}>
				<Input
					value={search} onInput={e => setSearch(e.currentTarget.value ?? "")}
					placeholder={"Rechercher..."} className={"self-start w-64"} leftIcon={<SearchIcon size={16} />}
				/>
				{ props.action }
			</div>


			{ /* Glass Table Container */ }
			<div
				className={clsx(
					"relative overflow-hidden",
					"ui-glass-panel",
				)}
			>
				<div className={"overflow-x-auto"}>
					<table className={"table-fixed min-w-full"}>
						<thead>
							<tr className={"border-b border-surface-1/20"}>
								{ props.columns.map((c) => {
									if (c === null) {
										return null;
									}
									const sortColumn = sort[c.id];
									if (c.visible !== false) {
										return (
											<Head
												sortable={sortColumn !== undefined}
												sort={sortColumn}
												setSortOrder={setOrder(c.id)}
												width={c.width}
											>
												{ c.name }
											</Head>
										);
									} else {
										return null;
									}
								}) }
							</tr>
						</thead>
						<tbody className={"divide-y divide-surface-1/10"}>
							{ data.data?.data?.map(d =>
								<tr className={"group transition-colors hover:bg-surface-0/20"}>
									{ props.line(d).filter((_, i) => props.columns[i]?.visible !== false) }
								</tr>) }
						</tbody>
					</table>
				</div>

				{ /* Pagination Footer */ }
				<div className={"px-6 py-4 border-t border-surface-1/30 bg-surface-0/10 flex items-center justify-between"}>
					<p className={"text-sm text-subtext-1"}>
						Page{ " " }
						<input
							className={"ui-control w-8 rounded-lg py-0.5 text-center"}
							value={data.data?.total_page === 0 ? 0 : page + 1}
							onInput={onPageChange}
						/>
						{ " " }sur <span className={"text-text font-medium"}>{ data.data?.total_page }</span>
					</p>
					<div className={"flex gap-2"}>
						<button
							className={clsx(
								"px-4 py-1.5 rounded-lg text-sm transition-colors",
								page === 0 ?
									"ui-control ui-control-disabled opacity-50" :
									"ui-control hover:bg-surface-1/50",
							)}
							onClick={() => setPage(prev => prev === 0 ? 0 : prev - 1)}
							disabled={page === 0}
						>
							Précédent
						</button>
						<button
							className={clsx(
								"px-4 py-1.5 rounded-lg text-sm transition-colors",

								page >= (data.data?.total_page ?? 1) - 1 ?
									"ui-control ui-control-disabled opacity-50" :
									"bg-surface-2/40 border border-surface-2/60 text-text hover:bg-surface-2/60",
							)}
							onClick={() => setPage(prev => prev >= (data.data?.total_page ?? 1) - 1 ? prev : prev + 1)}
							disabled={page >= (data.data?.total_page ?? 1) - 1}
						>
							Suivant
						</button>
					</div>
				</div>
			</div>
		</div>
	);
}

interface Columns {
	name: string,
	id: string,
	width?: string,
	visible?: boolean
}

interface TMetaData {
	[name: string]: string
}
