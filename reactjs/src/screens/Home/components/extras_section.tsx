import './food_section.scss';
import React, {useContext, useEffect, useState} from "react";
import {Link} from "react-router-dom";
import AuthContext from "../../../context/auth_context";
import Links from "../../../utils/links";
import {ExtraModel} from "../../../models/extra_model";
import {ExtrasBloc} from "../../../blocs/extra_bloc";
import Loader from '../../../components/loader/loader';
import ExtrasItem from '../../../components/extra_item/extra_item';

const ExtrasSection = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [extras, setExtras] = useState<ExtraModel[]>([]);
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchExtras();
    }, []);

    const fetchExtras = async () => {
        let extrasRetrieval: ExtraModel[] | null = await ExtrasBloc(accessToken ?? "").then(item => {
            setIsLoading(false);
            if (!item) {
                setError('خطایی رخ داده است');
            }
            return item;
        });
        setExtras(extrasRetrieval ?? []);
    }
    return (
        <>
        
        <div className='data-list section animate__animated animate__fadeIn'>
        <div className='section-header'>
            <h3>مخلفات</h3>
    <Link to='/extra/list'>دیدن همه</Link>
    </div>
    {isLoading || error !== null ? <div className='loading-sec'>
            {isLoading ? <Loader/> : <></>}
        {isLoading ? <p>درحال دریافت اطلاعات ...</p> : error ? <p>{error}</p> : <></>}
    </div> : <></>}
        <ul className='section-items'>
            {extras.slice(0, 7).map((item) => {
                    return <ExtrasItem item={item}/>
                })}
            </ul>
            </div>
        </>
    )
}

export default ExtrasSection;