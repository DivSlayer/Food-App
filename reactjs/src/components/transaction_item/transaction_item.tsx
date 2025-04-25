import React, {useEffect, useState} from "react";
import './transaction_item.scss';
import {TransactionModel, TransactionStatus} from "../../models/transaction_model";
import PriceFormatter from "../../utils/price_formatter";
import TimeFormatter from "../../utils/time_formatter";
import {Link} from "react-router-dom";
import CircularProgress from "@mui/material/CircularProgress";

interface props {
    item: TransactionModel;
}

const TransactionItem: React.FC<props> = ({item}) => {
    const [percent, setPercent] = useState(0);
    const [totalPrice, setTotalPrice] = useState<number>(0);

    const getStatus = (transaction: TransactionModel) => {
        switch (transaction.status) {
            case TransactionStatus.Pending:
                return 'در انتظار تایید';
            case TransactionStatus.Accepted:
                return 'تایید شده';
            case TransactionStatus.Declined:
                return 'رد شده';
            case TransactionStatus.Completed:
                return 'تکمیل شده';
            case TransactionStatus.Canceled:
                return 'کنسل شده';
            case TransactionStatus.Completing:
                return 'انتظار تحویل';
        }
    }

    useEffect(() => {
        let extras_price = item.orders.reduce((prev, currentValue) => {
            return prev + currentValue.extras.reduce((previous, current) => {
                return previous + (current.price * (current.quantity ?? 1));
            }, 0);
        }, 0);
        let instructions_price = item.orders.reduce((prev, currentValue) => {
            return prev + currentValue.instructions.reduce((previous, current) => {
                return previous + (current.price * (current.quantity ?? 1));
            }, 0);
        }, 0);
        let foods_price = item.orders.reduce((prev, currentValue) => {
            return prev + (currentValue.food.price ?? 0) * currentValue.quantity;
        }, 0);
        setTotalPrice(foods_price + instructions_price + extras_price);
        setTimer();
    }, []);

    const calculatePercentage = () => {
        let nowTime = new Date();
        let acceptedTime = item.changedAt;
        let total_time = item.totalDuration;
        const differenceInMilliseconds = nowTime.getTime() - acceptedTime.getTime();
        const differenceInMinutes = differenceInMilliseconds / (1000 * 60);
        setPercent(() => differenceInMinutes / total_time * 100);
    }

    const setTimer = ()=>{
        setInterval(calculatePercentage,1000);
    }

    return (
        <>
            <li className='transaction-item'>
                <Link to={'/transaction/' + item.serial}>
                    <div className='percentage'>
                        {item.status === TransactionStatus.Accepted ? <>
                            <CircularProgress variant="determinate" value={percent}
                                              className='custom-circular-progress'/>
                            <span className='percent'>{Math.ceil(percent*10) / 10}%</span>
                        </> : <></>}
                    </div>
                    <div className='details'>
                        <p className='active'>
                            <span className='key'>شماره تراکنش:</span>
                            <span className='value'>{item.serial}</span>
                        </p>
                        <p>
                            <span className='key'>تاریخ ثبت:</span>
                            <span className='value ltr'>1402/12/05 20:30</span>
                        </p>
                        <p>
                            <span className='key'>وضعیت:</span>
                            <span className={'value status ' + item.status.toLowerCase()}>{getStatus(item)}</span>
                        </p>
                        <p>
                            <span className='key'>مبلغ سفارش:</span>
                            <span
                                className='value'>{PriceFormatter(item.totalPrice)} تومان</span>
                        </p>
                        <p>
                            <span className='key'>زمان آماده سازی:</span>
                            <span
                                className='value'>{TimeFormatter(item.totalDuration * 60)} دقیقه</span>
                        </p>
                        <p>
                            <span className='key'>زمان پذیرش: </span>
                            <span className='value ltr'>{item.changedAt.toLocaleString()}</span>
                        </p>
                    </div>
                </Link>
            </li>
        </>
    )
}

export default TransactionItem;