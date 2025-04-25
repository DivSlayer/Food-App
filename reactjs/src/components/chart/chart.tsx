import React from "react";
import {
    AreaChart,
    Area,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    Legend,
    ResponsiveContainer,
} from "recharts";

// Define the interface for your income data.
interface IncomeData {
    date: string;
    income: number;
}

interface AreaChartProps {
    data: IncomeData[];
}


const AreaChartComponent: React.FC<AreaChartProps> = ({data}) => {

    return (
        <ResponsiveContainer width="100%" height={400}>
            <AreaChart data={data}>
                <CartesianGrid strokeDasharray="3 3"/>
                <XAxis
                    dataKey="date"
                />
                <YAxis
                    label={{value: 'درآمد (ریال)', angle: -90, position: 'insideLeft', offset: 10}} // Y-axis label
                />
                <Tooltip/>
                <Legend/>
                <Area
                    type="monotone"
                    dataKey="income"
                    stroke="#82ca9d"
                    fillOpacity={0.5}
                    fill="#82ca9d"
                />
            </AreaChart>
        </ResponsiveContainer>
    );
};

export default AreaChartComponent;