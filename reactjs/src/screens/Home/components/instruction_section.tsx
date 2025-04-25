import './food_section.scss';
import React, {useContext, useEffect, useState} from "react";
import {Link} from "react-router-dom";
import AuthContext from "../../../context/auth_context";
import Links from "../../../utils/links";
import {InstructionModel} from "../../../models/instruction_model";
import Loader from '../../../components/loader/loader';
import InstructionItem from '../../../components/instruction_item/instruction_item';
import { InstructionBloc } from '../../../blocs/instruction_bloc';

const InstructionsSection = () => {
    const [isLoading, setIsLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [instructions, setInstructions] = useState<InstructionModel[]>([]);
    let {accessToken} = useContext(AuthContext);

    useEffect(() => {
        fetchInstructions();
    }, []);

    const fetchInstructions = async () => {
        let instructionsRetrieval: InstructionModel[] | null = await InstructionBloc(accessToken ?? "").then(item => {
            setIsLoading(false);
            if (!item) {
                setError('خطایی رخ داده است');
            }
            return item;
        });
        setInstructions(instructionsRetrieval ?? []);
    }
    return (
        <>
        
        <div className='section instructions-section mt-3'>
        <div className='section-header'>
            <h3>اضافیجات</h3>
    <Link to='/instruction/list'>دیدن همه</Link>
    </div>
    {isLoading || error !== null ? <div className='loading-sec'>
            {isLoading ? <Loader/> : <></>}
        {isLoading ? <p>درحال دریافت اطلاعات ...</p> : error ? <p>{error}</p> : <></>}
    </div> : <></>}
        <ul className='section-items'>
            {instructions.slice(0, 7).map((item) => {
                    return <InstructionItem item={item}/>
                })}
            </ul>
            </div>
        </>
    )
}

export default InstructionsSection;