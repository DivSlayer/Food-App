import './transaction_section.scss'
import {Link} from "react-router-dom";
import TransactionItem from "../../../components/transaction_item/transaction_item";
import {useContext, useEffect, useState} from "react";
import AuthContext from "../../../context/auth_context";
import {TransactionModel} from "../../../models/transaction_model";
import Loader from "../../../components/loader/loader";
import {TransactionBloc} from "../../../blocs/transaction_bloc";
import transaction_list from "../../Transaction/transaction_list";

const TransactionSection = () => {
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
        let transactionList: TransactionModel[] | null = await TransactionBloc(accessToken??"");
        if (transactionList) {
            setTransactions(transactionList);
        }
        return !!transactionList;
    }

    return (
        <div className='section transaction-section mt-4'>
            <div className='section-header'>
                <h3>آخرین سفارش ها</h3>
                <Link to='/transaction/list'>دیدن همه</Link>
            </div>
            {isLoading || error !== null ? <div className='loading-sec'>
                {isLoading ? <Loader/> : <></>}
                {isLoading ? <p>درحال دریافت اطلاعات ...</p> : error ? <p>{error}</p> : <></>}
            </div> : <></>}
            <ul className='section-items'>
                {
                    transactions.slice(0,6).map(e => {
                        return <>
                            <TransactionItem item={e}/>
                        </>
                    })
                }
            </ul>
        </div>
    )
}

export default TransactionSection;