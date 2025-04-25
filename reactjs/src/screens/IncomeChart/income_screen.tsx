import Chart from "../../components/chart/chart";
import './income-screen.scss';
import axios from "axios";
import Links from '../../utils/links';
import {useContext, useEffect, useState} from "react";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import {format} from "date-fns";
import PriceFormatter from "../../utils/price_formatter";

interface IncomeData {
    date: string;
    income: number;
}

export default function IncomeScreen() {
    const [data, setData] = useState<IncomeData[]>([]);
    const [isLoading, setIsLoading] = useState(true);
    const [monthIncome, setMonthIncome] = useState<number>(0);

    let {accessToken} = useContext(AuthContext)

    useEffect(() => {
        fetchIncome();
    }, []);

    function isDateInCurrentMonth(date: Date): boolean {
        const now = new Date();
        return date.getFullYear() === now.getFullYear() && date.getMonth() === now.getMonth();
    }

    function filterDatesInCurrentMonth(data: IncomeData[]): IncomeData[] {
        return data.filter(item => isDateInCurrentMonth(new Date(item.date)));
    }

    const fetchIncome = async () => {
        let link = Links.transactionLink('income');
        await axios.get(link, {
            headers: {
                'Content-Type': 'multipart/form-data',
                Authorization: `Bearer ${accessToken}`,
            },
        }).then(response => {
            setIsLoading(false);
            let newData = response.data as { date: string, income: number }[];
            let monthItems = filterDatesInCurrentMonth(newData);
            let total_income = monthItems.reduce((prev, next) => prev + next.income, 0);
            setMonthIncome(total_income);
            let dateOrdered: IncomeData[] = newData.map((item) => {
                return {
                    date: format(new Date(item.date), 'yyyy-MM-dd'),
                    income: item.income,
                }
            });
            setData(dateOrdered);

        })
    }
    return (
        <div className='income-screen'>
            <h1 className='animate__animated animate__fadeInDown'>درآمد</h1>
            <div className='chart-holder animate__animated animate__fadeInUp'>
                {isLoading ? <Loader/> : <>
                    <Chart data={data}/>
                    <span className='total-income'>مجموع درآمد این ماه: {PriceFormatter(monthIncome)} ریال</span>
                </>}
            </div>
        </div>
    )
}