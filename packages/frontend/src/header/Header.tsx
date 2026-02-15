/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Theme } from "../theme/context.tsx";
import {
	DropDown,
	DropDownElement,
} from "../components/DropDown/DropDown.tsx";
import { useUser } from "../user/useUser.tsx";
import { useAuth } from "../auth/context.tsx";
import { useMemo } from "preact/hooks";
import {
	Sun, Moon, Monitor, Menu,
} from "lucide-preact";
import { ReactElement } from "react";
import { useSideBar } from "../sidebar/useSideBar.tsx";
import "./Header.css";
import { clsx } from "clsx";

interface HeaderProps {
	setTheme: (theme: Theme) => void
}

export function Header(props: HeaderProps) {
	const { setTheme } = props;
	const { user } = useUser();
	const { disconnect } = useAuth();
	const { setVisible } = useSideBar();

	const dropdownOptions = useMemo<[Theme, ReactElement, string][]>(
		() => [
			[
				"light",
				<Sun size={16} />,
				"Clair",
			],
			[
				"dark",
				<Moon size={16} />,
				"Sombre",
			],
			[
				"os",
				<Monitor size={16} />,
				"Système",
			],
		],
		[],
	);

	return (
		<header className={"flex justify-between md:justify-end items-center gap-4 relative z-10"}>
			<button
				className={clsx(
					"md:!hidden",
					"flex items-center gap-2 px-4 py-2 rounded-xl",
					"bg-surface-0/40 backdrop-blur-md border border-surface-2/30",
					"text-text hover:bg-surface-0/60 transition-all",
				)}
				onClick={() => setVisible(true)}
			>
				<Menu size={18} />
				<span className={"text-sm"}>Menu</span>
			</button>
			<div className={"flex items-center gap-3"}>
				<DropDown text={"Theme"}>
					{ dropdownOptions.map(([
											  theme,
											  icon,
											  text,
										  ]) =>
						<DropDownElement
							onClick={(e) => {
								e.stopPropagation();
								setTheme(theme);
							}}
						>
							{ icon }
							{ text }
						</DropDownElement>) }
				</DropDown>
				<DropDown text={user?.username}>
					<DropDownElement onClick={disconnect}>Se déconnecter</DropDownElement>
				</DropDown>
			</div>
		</header>
	);
}
