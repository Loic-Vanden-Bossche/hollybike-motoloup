/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Header } from "./header/Header.tsx";
import { useTheme } from "./theme/context.tsx";
import { Outlet } from "react-router-dom";
import { SideBar } from "./sidebar/SideBar.tsx";
import { clsx } from "clsx";

export function Root() {
	const theme = useTheme();

	return (
		<>
			<div
				className={clsx(
					"bg-mantle overflow-hidden min-h-full p-4 md:p-8",
					"flex flex-col gap-6 md:pl-60",
					"transition-all duration-200 relative",
				)}
			>
				{ /* Background blobs for glassmorphism ambient depth */ }
				<div className="fixed top-[-10%] left-[-10%] w-[40%] h-[40%] bg-mauve/10 blur-[120px] rounded-full pointer-events-none" />
				<div className="fixed bottom-[0%] right-[-5%] w-[35%] h-[35%] bg-blue/10 blur-[120px] rounded-full pointer-events-none" />
				<div className="fixed top-[20%] right-[10%] w-[25%] h-[25%] bg-pink/5 blur-[100px] rounded-full pointer-events-none" />

				<Header setTheme={theme.set}/>
				<Outlet/>
			</div>
			<SideBar/>
		</>
	);
}
