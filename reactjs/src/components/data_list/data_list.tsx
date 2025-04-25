import './data_list.scss';  
import React, { useContext, useEffect, useState } from 'react';  
import Loader from '../../components/loader/loader';  
import AuthContext from '../../context/auth_context';  
import { Link } from 'react-router-dom';

interface DataListProps<T> {  
    fetchFunction: () => Promise<T[] | null>;  
    renderItem: (item: T) => React.ReactNode;  
    title: string;  
    addLink:string;
}  

function DataList<T>({ fetchFunction, renderItem, title,addLink }: DataListProps<T>) {  
    const [isLoading, setIsLoading] = useState(true);  
    const [error, setError] = useState<string | null>(null);  
    const [data, setData] = useState<T[]>([]);  
    const { accessToken } = useContext(AuthContext);  

    useEffect(() => {  
        const fetchData = async () => {  
            setIsLoading(true);  
            const result = await fetchFunction();  
            setIsLoading(false);  
            if (!result) {  
                setError('خطایی رخ داده است');  
            } else {  
                setData(result);  
            }  
        };  

        fetchData();  
    }, [fetchFunction]);  

    return (  
        <div className='section mt-3 data-list'>  
            <div className='section-header'>  
                <h3 className='header'>{title}</h3>  
                <Link to={addLink} className='btn yellow-btn add-btn'>اضافه کردن</Link>
            </div>  
            {isLoading || error !== null ? (  
                <div className='loading-sec'>  
                    {isLoading ? <Loader /> : <p>{error}</p>}  
                    {isLoading && <p>درحال دریافت اطلاعات ...</p>}  
                </div>  
            ) : (  
                <ul className='section-items'>  
                    {data.map((item) => renderItem(item))}  
                </ul>  
            )}  
        </div>  
    );  
}  

export default DataList;