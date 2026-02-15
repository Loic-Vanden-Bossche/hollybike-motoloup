/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { Card } from "../components/Card/Card.tsx";
import {
	api, useApi,
} from "../utils/useApi.ts";
import { TOnboarding } from "../types/TOnboarding.ts";
import { CheckBox } from "../components/CheckBox.tsx";
import {
	useEffect, useState,
} from "preact/hooks";
import { equals } from "../utils/equals.ts";
import { Link } from "react-router-dom";
import { useUser } from "../user/useUser.tsx";

export function Home() {
	const onboarding = useApi<TOnboarding>("/associations/me/onboarding", []);
	const user = useUser();
	const [localOnboarding, setLocalOnboarding] = useState<TOnboarding | undefined>(onboarding.data);

	useEffect(() => {
		setLocalOnboarding(onboarding.data);
	}, [setLocalOnboarding, onboarding]);

	useEffect(() => {
		if (!equals(localOnboarding, onboarding.data) && localOnboarding !== undefined) {
			api<TOnboarding>("/associations/me/onboarding", {
				method: "PATCH",
				body: localOnboarding,
			}).then((res) => {
				if (res.status === 400) {
					setLocalOnboarding(onboarding.data);
				}
			});
		}
	}, [
		localOnboarding,
		onboarding,
		setLocalOnboarding,
	]);

	return (
		<div className={"flex flex-col gap-6"}>
			{ onboarding.data &&
				<Card>
					<h2 className={"text-xl font-bold tracking-tight mb-6"}>Mon onboarding</h2>
					<div className={"flex flex-col gap-4"}>
						<div className={"flex items-center gap-3 p-3 rounded-xl hover:bg-surface-0/40 transition-colors"}>
							<CheckBox
								checked={localOnboarding?.update_default_user}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return prev;
									} else {
										return {
											...prev,
											update_default_user: !prev.update_default_user,
										};
									}
								})}
							/>
							<Link className={"text-sm hover:text-blue transition-colors"} to={`/users/${ user.user?.id}`}>Mettre à jour l'utilisateur par défaut</Link>
						</div>
						<div className={"flex items-center gap-3 p-3 rounded-xl hover:bg-surface-0/40 transition-colors"}>
							<CheckBox
								checked={localOnboarding?.update_association}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return prev;
									} else {
										return {
											...prev,
											update_association: !prev.update_association,
										};
									}
								})}
							/>
							<Link className={"text-sm hover:text-blue transition-colors"} to={`/associations/${ user.user?.association?.id}`}><span>Personnaliser l'association</span></Link>
						</div>
						<div className={"flex items-center gap-3 p-3 rounded-xl hover:bg-surface-0/40 transition-colors"}>
							<CheckBox
								checked={localOnboarding?.create_invitation}
								toggle={() => setLocalOnboarding((prev) => {
									if (prev === undefined) {
										return undefined;
									} else {
										return {
											...prev,
											create_invitation: !prev.create_invitation,
										};
									}
								})}
							/>
							<Link className={"text-sm hover:text-blue transition-colors"} to={`associations/${ user.user?.association.id }/invitations/`}>
								<span>Créer une invitation</span>
							</Link>
						</div>
					</div>
				</Card> }
		</div>
	);
}
