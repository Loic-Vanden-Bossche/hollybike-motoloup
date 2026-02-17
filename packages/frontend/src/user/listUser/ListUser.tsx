/*
  Hollybike Back-office web application
  Made by MacaronFR (Denis TURBIEZ) and enzoSoa (Enzo SOARES)
*/
import { List } from "../../components/List/List.tsx";
import { TUser } from "../../types/TUser.ts";
import { Cell } from "../../components/List/Cell.tsx";
import {
	Link, useNavigate, useParams,
} from "react-router-dom";
import { useSideBar } from "../../sidebar/useSideBar.tsx";
import { api } from "../../utils/useApi.ts";
import { TAssociation } from "../../types/TAssociation.ts";
import {
	useEffect, useMemo,
} from "preact/hooks";
import { ExternalLink } from "lucide-preact";
import { equals } from "../../utils/equals.ts";
import { Card } from "../../components/Card/Card.tsx";
import { EUserStatusToString } from "../../types/EUserStatus.ts";
import { EUserScopeToString } from "../../types/EUserScope.ts";

export function ListUser() {
	const {
		association, setAssociation,
	} = useSideBar();

	const { id } = useParams();
	const navigate = useNavigate();
	const isAssociationIdValid = useMemo(() => id === undefined || /^[0-9]+$/.test(id), [id]);

	useEffect(() => {
		if (!isAssociationIdValid) {
			navigate("/not-found", { replace: true });
			return;
		}

		if (id && (association === undefined || association.id.toString() !== id)) {
			api<TAssociation>(`/associations/${id}`).then((res) => {
				if (res.status === 200 && res.data !== null && res.data !== undefined) {
					if (!equals(res.data, association)) {
						setAssociation(res.data);
					}
				} else if (res.status === 404 || res.status === 400) {
					navigate("/not-found", { replace: true });
				}
			});
		}
	}, [
		id,
		setAssociation,
		association,
		isAssociationIdValid,
		navigate,
	]);

	const filter = useMemo(() => {
		if (id === undefined) {
			return "";
		}
		if (association === undefined) {
			return `id_association=eq:${id}`;
		} else {
			return `id_association=eq:${association.id}`;
		}
	}, [id, association]);

	if (!isAssociationIdValid) {
		return null;
	}

	return (
		<Card>
			<List
				line={(u: TUser) => [
					<Cell><Link to={`/users/${u.id}`}><ExternalLink size={16} /></Link></Cell>,
					<Cell>{ u.email }</Cell>,
					<Cell>{ u.username }</Cell>,
					<Cell>{ EUserScopeToString(u.scope) }</Cell>,
					<Cell>{ EUserStatusToString(u.status) }</Cell>,
					<Cell>{ new Date(u.last_login).toLocaleString() }</Cell>,
					<Cell><Link to={`/associations/${u.association.id}`}>{ u.association.name }</Link></Cell>,
				]}
				columns={[
					{
						name: "",
						id: "",
					},
					{
						name: "Mail",
						id: "email",
						width: "",
					},
					{
						name: "Pseudo",
						id: "username",
					},
					{
						name: "Role",
						id: "scope",
					},
					{
						name: "Statut",
						id: "status",
					},
					{
						name: "Dernière Connexion",
						id: "last_login",
					},
					{
						name: "Association",
						id: "associations",
					},
				]}
				baseUrl={"/users"} filter={filter}
			/>
		</Card>
	);
}
