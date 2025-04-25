import './transaction_list.scss'
import TransactionItem from "../../components/transaction_item/transaction_item";
import {useContext, useEffect, useState} from "react";
import {TransactionModel} from "../../models/transaction_model";
import AuthContext from "../../context/auth_context";
import {TransactionBloc} from "../../blocs/transaction_bloc";
import Loader from "../../components/loader/loader";

function TransactionList() {
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [transactions, setTransactions] = useState<TransactionModel[]>([]);

    let {accessToken} = useContext(AuthContext);
    useEffect(() => {
        fetchTransactions().then((result) => {
            setIsLoading(false);
            if (!result) {
                setError('خطایی رخ داده است');
            }
        });
    }, []);
    const fetchTransactions = async (): Promise<boolean> => {
        let transactionList: TransactionModel[] | null = await TransactionBloc(accessToken ?? "");
        if (transactionList) {
            setTransactions(transactionList);
        }
        return !!transactionList;
    }

    return (
        <div className='transaction_list section animate__animated animate__fadeInDown'>
            <h1 className='header'>لیست سفارش ها</h1>
            {isLoading || error !== null ? <div className='loading-sec'>
                {isLoading ? <Loader/> : <></>}
                {isLoading ? <p>درحال دریافت اطلاعات ...</p> : error ? <p>{error}</p> : <></>}
            </div> : <></>}
            <ul className='section-items'>
                {
                    transactions.map((e) => {
                        return (
                            <>
                                <TransactionItem item={e}/>
                            </>
                        )
                    })
                }
            </ul>
        </div>
    )
}

export default TransactionList