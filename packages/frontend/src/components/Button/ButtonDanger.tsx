/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import {
	Button, ButtonProps,
} from "./Button.tsx";
import { clsx } from "clsx";

export function ButtonDanger(props: ButtonProps) {
	return (
		<Button
			{...props}
			className={clsx(
				"!bg-red/10 !text-red !border !border-red/20 !shadow-none hover:!bg-red/20",
				props.className,
			)}
		>
			{ props.children }
		</Button>
	);
}
