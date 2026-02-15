/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { SideBarMenu } from "./SideBarMenu.tsx";
import { useUser } from "../user/useUser.tsx";
import { useMemo } from "preact/hooks";
import { useSideBar } from "./useSideBar.tsx";
import { TAssociation } from "../types/TAssociation.ts";
import { useApi } from "../utils/useApi.ts";
import { TOnPremise } from "../types/TOnPremise.ts";
import { clsx } from "clsx";
import { X } from "lucide-preact";
import { Link } from "react-router-dom";

export function SideBar() {
	const { user } = useUser();
	const {
		association, visible, setVisible,
	} = useSideBar();
	const onPremise = useApi<TOnPremise>("/on-premise");

	const content = useMemo(() => {
		if (user?.scope === "Root") {
			return rootMenu(association, onPremise.data?.is_on_premise ?? false);
		} else {
			return adminMenu(user?.association, false, onPremise.data?.is_on_premise ?? false);
		}
	}, [user, association]);

	return (
		<div
			className={
				clsx(
					"fixed left-0 right-0 top-0 bottom-0 md:bg-transparent p-4",
					"transition-all duration-200",
					visible ?
						"bg-crust/40 backdrop-blur-sm pointer-events-auto cursor-pointer" :
						"bg-transparent backdrop-blur-0 pointer-events-none",
				)
			}
			style={{ zIndex: 8_000 }}
			onClick={() => setVisible(false)}
		>
			<aside
				className={clsx(
					"relative w-52 min-w-52 h-full pointer-events-auto cursor-auto",
					"bg-surface-0/30 backdrop-blur-xl",
					"border border-surface-2/30",
					"rounded-3xl shadow-[0_8px_32px_0_rgba(0,0,0,0.15)]",
					"flex-col flex md:translate-x-0 gap-1 p-3",
					"transition-transform duration-200",
					visible ? "translate-x-0" : "-translate-x-[calc(100%+4rem)]",
				)}
				onClick={(e) => e.stopPropagation()}
			>
				{/* Logo */}
				<Link className={"self-stretch"} to={"/"}>
					<div
						className={clsx(
							"flex overflow-hidden h-20 rounded-2xl",
							"relative justify-center items-center bg-logo",
							"border border-surface-2/20",
						)}
					>
						<img alt={"HOLLYBIKE"} className={"text-black text-3xl italic"} src={"/icon.png"}/>
					</div>
				</Link>

				{/* Close button (mobile) */}
				<button
					className={clsx(
						"absolute top-4 right-4 md:hidden",
						"p-2 rounded-xl",
						"bg-surface-0/40 backdrop-blur-md border border-surface-2/30",
						"text-subtext-1 hover:text-text hover:bg-surface-0/60",
						"transition-all",
					)}
					onClick={() => setVisible(false)}
				>
					<X size={16} />
				</button>

				{/* Navigation */}
				<div className={clsx("h-full flex flex-col overflow-y-auto gap-1 mt-2")}>
					{ content }
				</div>
			</aside>
		</div>
	);
}

function adminMenu(association: TAssociation | undefined, root: boolean, onPremise: boolean) {
	let menus = [
		<SideBarMenu to={`/associations/${association?.id}`}>
			{ root ? association?.name : "Mon association" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/invitations`} indent={root}>
			{ root ? "Invitations" : "Mes invitations" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/users`} indent={root}>
			{ root ? "Utilisateurs" : "Mes utilisateurs" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/events`} indent={root}>
			{ root ? "Événements" : "Mes événements" }
		</SideBarMenu>,
		<SideBarMenu to={`/associations/${association?.id}/journeys`} indent={root}>
			{ root ? "Bibliothèque de trajet" : "Mes trajets" }
		</SideBarMenu>,
	];
	if (onPremise) {
		menus.push(<SideBarMenu to={"/conf"}>Configuration</SideBarMenu>);
	}
	if (root) {
		menus = [
			<div className={"mx-4 my-2"}>
				<div className={"h-px bg-surface-2/30"} />
			</div>,
			...menus,
		];
	}
	return menus;
}

function rootMenu(association: TAssociation | undefined, onPremise: boolean) {
	const menu = [
		<p className={"text-[10px] font-bold uppercase tracking-[0.2em] text-subtext-1 px-4 mb-1 mt-3"}>
			Navigation
		</p>,
		<SideBarMenu to={"/associations"}>
			Associations
		</SideBarMenu>,
		<SideBarMenu to={"/invitations"}>
			Invitations
		</SideBarMenu>,
		<SideBarMenu to={"/users"}>
			Utilisateurs
		</SideBarMenu>,
		<SideBarMenu to={"/events"}>
			Événements
		</SideBarMenu>,
		<SideBarMenu to={"/journeys"}>
			Bibliothèque de trajet
		</SideBarMenu>,
	];
	if (association !== undefined) {
		menu.push(
			<p className={"text-[10px] font-bold uppercase tracking-[0.2em] text-subtext-1 px-4 mb-1 mt-3"}>
				{association.name}
			</p>,
		);
		menu.push(...adminMenu(association, true, onPremise));
	}
	return menu;
}
