/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import { TExpense } from "../types/TExpense.ts";
import { Button } from "../components/Button/Button.tsx";
import {
	Dispatch, StateUpdater, useState,
} from "preact/hooks";
import { Modal } from "../components/Modal/Modal.tsx";
import { dateToFrenchString } from "../components/Calendar/InputCalendar.tsx";

import { DoReload } from "../utils/useReload.ts";
import {
	Pencil,
	ChevronDown, Eye,
} from "lucide-preact";
import { clsx } from "clsx";
import { ExpenseEditAddModal } from "./ExpenseEditAddModal.tsx";

interface EventExpenseProps {
	expenses: TExpense[],
	eventId: number,
	doReload: DoReload
}

export function EventExpense(props: EventExpenseProps) {
	const {
		expenses, eventId, doReload,
	} = props;
	const [display, setDisplay] = useState(false);
	const [type, setType] = useState<"add" | "edit">("add");
	const [data, setData] = useState<TExpense>();
	return (
		<Card className={"grow-[1] overflow-hidden flex flex-col"}>
			<div className={"flex justify-between items-center mb-4"}>
				<h2 className={"text-xl font-bold tracking-tight"}>Dépenses</h2>
				<Button
					onClick={() => {
						setDisplay(true);
						setType("add");
					}}
				>
					Ajouter
				</Button>
			</div>
			<div className={"overflow-auto flex flex-col gap-1"}>
				{ expenses.map((expense, index) =>
					<Expense
						expense={expense}
						key={index}
						setEditModalVisibility={setDisplay}
						setData={setData}
						setType={setType}
					/>) }
			</div>
			<ExpenseEditAddModal
				type={type}
				setData={setData}
				visible={display}
				setVisible={setDisplay}
				eventId={eventId}
				doReload={doReload}
				data={data}
			/>
		</Card>
	);
}

interface ExpenseProps {
	expense: TExpense,
	setEditModalVisibility: Dispatch<StateUpdater<boolean>>,
	setData: Dispatch<StateUpdater<TExpense | undefined>>,
	setType: Dispatch<StateUpdater<"add" | "edit">>
}

function Expense(props: ExpenseProps) {
	const [visible, setVisible] = useState(false);
	const [modal, setModal] = useState(false);
	return (
		<div className={"cursor-pointer overflow-hidden p-3 rounded-xl hover:bg-surface-0/40 transition-all"} onClick={() => setVisible(!visible)}>
			<div className={"flex justify-between items-center"}>
				<div className={"flex gap-3 items-center"}>
					<p className={"text-sm font-medium"}>{ props.expense.name }</p>
					<span className={"text-xs font-semibold px-2 py-0.5 rounded-full bg-blue/10 text-blue border border-blue/20"}>{ (props.expense.amount / 100).toFixed(2) } €</span>
					<p className={"text-xs text-subtext-0"}>{ dateToFrenchString(props.expense.date) }</p>
				</div>
				<ChevronDown size={16} className={clsx("transition-transform", visible && "rotate-180")}/>
			</div>
			<div className={clsx("transition-all overflow-hidden flex justify-between items-center", visible && "max-h-20 mt-2" || "max-h-0")}>
				<p className={"text-sm text-subtext-0"}>{ props.expense.description }</p>
				<div className={"flex gap-2"}>
					<Pencil
						size={16}
						className={"cursor-pointer text-subtext-1 hover:text-text transition-colors"}
						onClick={(e: MouseEvent) => {
							props.setEditModalVisibility(true);
							props.setData(props.expense);
							props.setType("edit");
							e.stopPropagation();
						}}
					/>
					{ props.expense.proof && <Eye
						size={16}
						className={"cursor-pointer text-subtext-1 hover:text-text transition-colors"}
						onClick={(e: MouseEvent) => {
							setModal(true);
							e.stopPropagation();
						}}
					/> }
				</div>
			</div>
			<Modal visible={modal} setVisible={setModal}>
				<img className={"rounded-xl"} alt={"Preuve d'achat"} src={props.expense.proof}/>
			</Modal>
		</div>
	);
}
