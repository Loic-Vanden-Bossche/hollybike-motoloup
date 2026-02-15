import {
	useEffect,
	useRef,
	useState,
} from "preact/hooks";
import { clsx } from "clsx";
import {
	EChartsCoreOption,
	EChartsType,
	init,
	use,
} from "echarts/core";
import { BarChart } from "echarts/charts";
import { PieChart } from "echarts/charts";
import {
	GridComponent,
	LegendComponent,
	TitleComponent,
	TooltipComponent,
} from "echarts/components";
import { CanvasRenderer } from "echarts/renderers";

use([
	BarChart,
	PieChart,
	TooltipComponent,
	GridComponent,
	LegendComponent,
	TitleComponent,
	CanvasRenderer,
]);

interface EChartProps {
	option: EChartsCoreOption,
	height?: number,
	className?: string
}

export function EChart({
	option,
	height = 320,
	className,
}: EChartProps) {
	const containerRef = useRef<HTMLDivElement>(null);
	const chartRef = useRef<EChartsType | null>(null);
	const [visible, setVisible] = useState(false);

	useEffect(() => {
		if (containerRef.current === null) {
			return;
		}

		const chart = init(containerRef.current);
		chartRef.current = chart;

		const observer = new ResizeObserver(() => {
			chart.resize();
		});
		observer.observe(containerRef.current);

		return () => {
			observer.disconnect();
			chart.dispose();
			chartRef.current = null;
		};
	}, []);

	useEffect(() => {
		if (chartRef.current === null) {
			return;
		}
		setVisible(false);
		chartRef.current.setOption({
			animation: "auto",
			animationDuration: 1_000,
			animationDurationUpdate: 500,
			animationEasing: "cubicInOut",
			animationEasingUpdate: "cubicInOut",
			animationThreshold: 2_000,
			progressiveThreshold: 3_000,
			progressive: 400,
			hoverLayerThreshold: 3_000,
			useUTC: false,
			...option,
		} as any, true);
		requestAnimationFrame(() => {
			setVisible(true);
		});
	}, [option]);

	return (
		<div
			ref={containerRef}
			className={clsx(
				"w-full transition-opacity duration-500",
				visible ? "opacity-100" : "opacity-0",
				className,
			)}
			style={{ height: `${height}px` }}
		/>
	);
}
