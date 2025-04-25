import {useParams} from "react-router-dom";
import {TransactionModel, TransactionStatus} from "../../models/transaction_model";
import {TransactionBloc} from "../../blocs/transaction_bloc";
import React, {useContext, useEffect, useRef, useState} from "react";
import AuthContext from "../../context/auth_context";
import Loader from "../../components/loader/loader";
import './single_transaction.scss';
import PriceFormatter from "../../utils/price_formatter";
import axios from "axios";
import Links from "../../utils/links";
import FormGroup from "../../components/forms/form-group";

const SingleTransaction = () => {
    const routerParams = useParams();
    const [transaction, setTransaction] = useState<TransactionModel | null>();
    const [isLoading, setIsLoading] = useState<boolean>(true);
    const [totalPrice, setTotalPrice] = useState<number>(0);
    const [statusText, setStatusText] = useState<string>();
    const [deliveryCode,setDeliveryCode] = useState<string|null>();

    const serial: string = routerParams.serial ?? "";
    let {accessToken} = useContext(AuthContext);
    useEffect(() => {
        fetchTransaction();
    }, []);

    useEffect(() => {
        if (transaction) {
            let extras_price = transaction.orders.reduce((prev, currentValue) => {
                return prev + currentValue.extras.reduce((previous, current) => {
                    return previous + (current.price * (current.quantity ?? 1));
                }, 0);
            }, 0);
            let instructions_price = transaction.orders.reduce((prev, currentValue) => {
                return prev + currentValue.instructions.reduce((previous, current) => {
                    return previous + (current.price * (current.quantity ?? 1));
                }, 0);
            }, 0);
            let foods_price = transaction.orders.reduce((prev, currentValue) => {
                return prev + (currentValue.food.sizes[0].price ?? 0) * currentValue.quantity;
            }, 0);
            setTotalPrice(foods_price + instructions_price + extras_price);
            switch (transaction.status) {
                case TransactionStatus.Pending:
                    setStatusText('در انتظار تایید');
                    break;
                case TransactionStatus.Accepted:
                    setStatusText('تایید شده');
                    break;
                case TransactionStatus.Declined:
                    setStatusText('رد شده');
                    break;
                case TransactionStatus.Completed:
                    setStatusText('تکمیل شده');
                    break;
                case TransactionStatus.Canceled:
                    setStatusText('کنسل شده');
                    break;
                case TransactionStatus.Completing:
                    setStatusText('انتظار تحویل');
                    break;
            }
        }
    }, [transaction]);

    const fetchTransaction = async () => {
        let found_transaction: TransactionModel[] | null = await TransactionBloc(accessToken ?? "", serial).then(item => {
            setIsLoading(false);
            return item;
        });
        if (found_transaction && found_transaction.length > 0) {
            setTransaction(found_transaction[0]);
        }
    }

    const changeStatus = async (value: string) => {
        let link = Links.transactionLink(serial) + (serial ? "" : "/");
        let data = {
            'status': value,
        };
        setIsLoading(true);
        await updateTransaction(link, data);

    }

    async function updateTransaction(link: string, data: Record<string, string>) {
        try {
            const response = await axios.put(
                link,
                data,
                {
                    headers: {
                        'Content-Type': 'application/json',
                        'Authorization': `Bearer ${accessToken}`  // Include this line if you are using token-based authentication
                    }
                }
            ).then((res) => {
                setIsLoading(false);
                return res;
            });
            setTransaction(TransactionModel.fromJson(response.data));
            return response.data;
        } catch (error) {
            console.error('Error updating transaction:', error);
            setIsLoading(false);
            throw error;
        }
    }

    const verifyCode = async () => {
        if (deliveryCode && deliveryCode.length > 0) {
            setIsLoading(true);
            let link = Links.transactionVerification(serial, deliveryCode);
            let data = {
                'code': deliveryCode,
            };
            await updateTransaction(link, data);
        }

    }

    return (
        <>
            <div className='single-transaction animate__animated animate__fadeInDown'>
                <div className='header'>
                    <h1>لیست سفارش به کد پیگیری {serial}</h1>
                    {
                        transaction?.status === TransactionStatus.Pending ? <div className='funcs'>
                            <button className='btn green-btn' onClick={() => changeStatus('AC')}>تایید</button>
                            <button className='btn red-btn' onClick={() => changeStatus('CA')}>لغو</button>
                        </div> : <></>
                    }
                </div>
                {
                    isLoading ? <div className='loading'>
                        <Loader/>
                    </div> : <>
                        <div className={'status ' + transaction?.status.toLowerCase()}>
                            وضعیت: {
                            statusText ? statusText : ""
                        }
                        </div>
                        {
                            (transaction?.status === TransactionStatus.Accepted || transaction?.status === TransactionStatus.Completing) ?
                                <div className='row col-gap-3'>
                                    <div style={{width: '40%'}}>
                                        <FormGroup label='کد دریافت' key='verify-code' name='verify-code'
                                                   keyboardType='number' update={(value) => {
                                                       setDeliveryCode(value);
                                        }}/>
                                    </div>
                                    <button className='btn blue-btn' style={{fontSize: '12px'}}
                                            onClick={verifyCode}>تایید کد
                                    </button>
                                </div> : <></>}
                        <div className='details'>
                            <h3 className='title'>مشخصات</h3>
                            <ul className='details-holder'>
                                <li>
                                    <span className='label'>نام گیرنده:</span>
                                    <span className='value'>{transaction?.clientName}</span>
                                </li>
                                <li>
                                    <span className='label'>شماره تماس گیرنده:</span>
                                    <span className='value'>{transaction?.address.client_phone}</span>
                                </li>
                                <li className='big'>
                                    <span className='label'>آدرس:</span>
                                    <span className='value'>{transaction?.address.brief_address}</span>
                                </li>
                                {totalPrice === 0 ? <></> : <li className='big'>
                                    <span className='label'>قیمت کل:</span>
                                    <span className='value yellow-color'>{PriceFormatter(totalPrice)} تومان</span>
                                </li>
                                }
                            </ul>
                        </div>
                        <div className='sec-holder'>
                            <h3 className='sec-header'>آیتم ها</h3>
                            <ul className='items'>
                                {
                                    transaction?.orders.map((item) => {
                                        return <li className='order'>
                                            <div className='food'>
                                                <div className='right'>
                                                    <div className='image'>
                                                        <img src={item.food.image} alt=''/>
                                                    </div>
                                                    <h3 className='name'>{item.food.name}</h3>
                                                    <span className='quantity'>
                                                    *{item.quantity}
                                                    </span>
                                                </div>
                                                <div className='left'>
                                                    <h2 className='price yellow-color'>{PriceFormatter((item.food.sizes[0].price ?? 0) * (item.quantity ?? 0))} تومان</h2>
                                                </div>
                                            </div>
                                            {item.extras.length > 0 ? <>
                                                <h5 className='list-title'>اضافیجات</h5>
                                                <ul className='extras'>
                                                    {item.extras.map(extra => {
                                                        return <li>
                                                            <div className='right'>
                                                                <img alt='extra' src={extra.icon}/>
                                                                <h4 className='name'>{extra.name}</h4>
                                                                <span className='quantity'>* {extra.quantity}</span>
                                                            </div>

                                                            <div className='left'>
                                                                <h2 className='price yellow-color'>{PriceFormatter((extra.price ?? 0) * (extra.quantity ?? 0))} تومان</h2>
                                                            </div>
                                                        </li>
                                                    })}
                                                </ul>
                                            </> : <></>}
                                            {item.instructions.length > 0 ? <>
                                                <h5 className='list-title'>دستور پخت</h5>
                                                <ul className='extras'>
                                                    {item.instructions.map(extra => {
                                                        return <li>
                                                            <div className='right'>

                                                                <img alt='extra' src={extra.image}/>
                                                                <h4 className='name'>{extra.name}</h4>
                                                                <span className='quantity'>* {extra.quantity}</span>
                                                            </div>
                                                            <div className='left'>
                                                                <h2 className='price yellow-color'>{PriceFormatter((extra.price ?? 0) * (extra.quantity ?? 0))} تومان</h2>
                                                            </div>
                                                        </li>
                                                    })}
                                                </ul>

                                            </> : <></>}
                                        </li>
                                    })
                                }
                            </ul>
                        </div>
                    </>
                }
            </div>
        </>
    )
}

export default SingleTransaction;